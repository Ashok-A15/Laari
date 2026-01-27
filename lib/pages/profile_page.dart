import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("owners")
        .doc(user.uid)
        .get();

    if (snap.exists) {
      setState(() {
        name = snap["name"];
        email = snap["email"];
        phone = snap["phone"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Owner Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: $name", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text("Email: $email", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text("Phone: $phone", style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
