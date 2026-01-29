import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'role_selection_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsSection("Account"),
          _buildSettingsTile(Icons.person_outline_rounded, "Profile Information", () {}),
          _buildSettingsTile(Icons.lock_outline_rounded, "Change Password", () {}),
          _buildSettingsTile(Icons.notifications_none_rounded, "Notifications", () {}),
          
          const SizedBox(height: 24),
          _buildSettingsSection("App Settings"),
          _buildSettingsTile(Icons.dark_mode_outlined, "Dark Mode", () {}, trailing: Switch(value: false, onChanged: (v) {})),
          _buildSettingsTile(Icons.language_rounded, "Language", () {}, subtitle: "English"),
          
          const SizedBox(height: 24),
          _buildSettingsSection("Support"),
          _buildSettingsTile(Icons.help_outline_rounded, "Help Center", () {}),
          _buildSettingsTile(Icons.policy_outlined, "Privacy Policy", () {}),
          
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
                  (route) => false,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {Widget? trailing, String? subtitle}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF185A9D)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }
}
