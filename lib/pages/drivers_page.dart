import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'add_driver_page.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Drivers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDriverPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Driver"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Dummy drivers list
            _driverCard("Amit Kumar", "+91 9876543210", context),
            _driverCard("Rajesh Gupta", "+91 9876552109", context),
            _driverCard("Sunil Sharma", "+91 9876523129", context),
            _driverCard("Vikas Patel", "+91 9876543287", context),
          ],
        ),
      ),
    );
  }

  Widget _driverCard(String name, String phone, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(phone, style: const TextStyle(color: Colors.black54)),
            ],
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: const Text("Edit"),
          )
        ],
      ),
    );
  }
}
