import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/bottom_nav.dart';
import '../widgets/owner_map.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String ownerName = "Owner";

  @override
  void initState() {
    super.initState();
    fetchOwnerName();
  }

  Future<void> fetchOwnerName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("owners")
        .doc(user.uid)
        .get();

    if (snap.exists && mounted) {
      setState(() {
        ownerName = snap["name"] ?? "Owner";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          "Laari Booking Platform",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $ownerName 👋",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _statCard("₹45,600", "Total Earnings", Colors.blue),
                const SizedBox(width: 12),
                _statCard("5", "Active Laaris", Colors.green),
                const SizedBox(width: 12),
                _statCard("7", "Active Drivers", Colors.orange),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Fleet Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const OwnerMap(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String title, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
