import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: service.ownerStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text("Owner data not found", style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          final data = snapshot.data!.data()!;
          final String name = data['name'] ?? 'N/A';
          final String email = data['email'] ?? 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark 
                        ? [const Color(0xFF1E272E), const Color(0xFF0F171A)]
                        : [const Color(0xFF43CEA2), const Color(0xFF185A9D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white24,
                        child: Text(
                          name.isNotEmpty ? name[0] : "O",
                          style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              email,
                              style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                Row(
                  children: [
                    Expanded(child: _statCard(context, "₹${data['totalEarnings'] ?? 0}", "Earnings", Icons.payments_rounded, Colors.green)),
                    const SizedBox(width: 16),
                    Expanded(child: _statCard(context, "${data['activeLaaris'] ?? 0}", "Laaris", Icons.local_shipping_rounded, Colors.blue)),
                  ],
                ),
                const SizedBox(height: 16),
                _statCard(context, "${data['activeDrivers'] ?? 0}", "Active Drivers", Icons.people_rounded, Colors.orange, fullWidth: true),
                
                const SizedBox(height: 40),
                
                _buildOption(context, Icons.history_rounded, "Transaction History"),
                _buildOption(context, Icons.headset_mic_rounded, "Support Center"),
                _buildOption(context, Icons.info_outline_rounded, "About GoLorry"),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label, IconData icon, Color color, {bool fullWidth = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: fullWidth ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF185A9D)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}
