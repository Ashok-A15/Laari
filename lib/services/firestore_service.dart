import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _cachedRole;
  String? _cachedOwnerId;

  String get currentUid => _auth.currentUser?.uid ?? "";

  // Get user role with caching
  Future<String> getUserRole() async {
    if (_cachedRole != null) return _cachedRole!;
    if (currentUid.isEmpty) return "guest";

    try {
      // Check owners collection
      final ownerDoc = await _db.collection('owners').doc(currentUid).get();
      if (ownerDoc.exists) {
        _cachedRole = 'owner';
        _cachedOwnerId = currentUid;
        return 'owner';
      }

      // Check drivers collection
      final driverDoc = await _db.collection('drivers').doc(currentUid).get();
      if (driverDoc.exists) {
        _cachedRole = 'driver';
        _cachedOwnerId = driverDoc.data()?['ownerId'];
        return 'driver';
      }
    } catch (e) {
      debugPrint("Error fetching role: $e");
    }

    return "unknown";
  }

  // Get the effective ownerId (Self for owner, Boss for driver)
  Future<String?> getEffectiveOwnerId() async {
    if (_cachedOwnerId != null) return _cachedOwnerId;
    await getUserRole();
    return _cachedOwnerId;
  }

  // Clear cache on logout
  void clearCache() {
    _cachedRole = null;
    _cachedOwnerId = null;
  }

  // Stream current user's profile (Owner or Driver)
  Stream<DocumentSnapshot<Map<String, dynamic>>> userProfileStream() {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // This is a bit complex for a stream, better to use combined streams or just logic in UI.
      // For now, let's keep it simple and assume the UI knows where to look or we check role first.
    }).asStream().cast(); // Placeholder, will refine if needed
  }

  // Stream owner profile (specifically for the owner profile screen)
  Stream<DocumentSnapshot<Map<String, dynamic>>> ownerStream(String uid) {
    return _db.collection('owners').doc(uid).snapshots();
  }

  // Create driver profile (Owner only)
  Future<void> createDriverProfile(String driverUid, Map<String, dynamic> data) async {
    await _db.collection('drivers').doc(driverUid).set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'role': 'driver',
    });
  }

  // Stream drivers for a specific owner
  Stream<QuerySnapshot<Map<String, dynamic>>> getDriversStream(String ownerId) {
    return _db.collection('drivers')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots();
  }

  // Update driver location
  Future<void> updateDriverLocation(double lat, double lng) async {
    if (currentUid.isEmpty) return;
    await _db.collection('drivers').doc(currentUid).update({
      'currentLocation': GeoPoint(lat, lng),
      'lastLocationUpdate': FieldValue.serverTimestamp(),
    });
  }

  // Update driver last login
  Future<void> updateLastLogin() async {
    if (currentUid.isEmpty) return;
    await _db.collection('drivers').doc(currentUid).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }
}
