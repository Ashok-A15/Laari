import 'package:flutter/material.dart';

class AddDriverPage extends StatelessWidget {
  const AddDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Driver"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Driver Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Fill in the information to add a new driver to your fleet.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 40),

            _inputField(label: "Driver Name", icon: Icons.person_outline_rounded),
            const SizedBox(height: 20),

            _inputField(label: "Mobile Number", icon: Icons.phone_android_rounded, keyboard: TextInputType.phone),
            const SizedBox(height: 20),

            _inputField(label: "Licence Number", icon: Icons.badge_outlined),
            const SizedBox(height: 20),

            _inputField(label: "City / Location", icon: Icons.location_on_outlined),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF185A9D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Register Driver",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField({required String label, required IconData icon, TextInputType? keyboard}) {
    return TextField(
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF43CEA2)),
      ),
    );
  }
}
