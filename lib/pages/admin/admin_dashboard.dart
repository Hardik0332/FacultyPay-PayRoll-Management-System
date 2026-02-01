import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_sidebars.dart'; // Import shared sidebar

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // ✅ USE THE SHARED SIDEBAR
          const AdminSidebar(activeRoute: '/admin/dashboard'),

          // MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Admin Dashboard", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),

                  // REAL-TIME STATS ROW
                  Row(
                    children: [
                      _StatCard(title: "Faculty Members", collection: "users", color: const Color(0xff45a182), icon: Icons.group),
                      const SizedBox(width: 16),
                      _StatCard(title: "Attendance Records", collection: "attendance", color: Colors.purple, icon: Icons.library_books),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _QuickAction(
                        icon: Icons.person_add,
                        title: "Add New Faculty",
                        onTap: () => Navigator.pushReplacementNamed(context, '/admin/add-faculty'),
                      ),
                      const SizedBox(width: 16),
                      _QuickAction(
                        icon: Icons.check_circle,
                        title: "Verify Attendance",
                        onTap: () => Navigator.pushReplacementNamed(context, '/admin/view-attendance'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Keep the internal components (_StatCard, _QuickAction) as they were in the previous code I sent,
// just ensure AdminSidebar is used.
class _StatCard extends StatelessWidget {
  final String title;
  final String collection;
  final Color color;
  final IconData icon;

  const _StatCard({required this.title, required this.collection, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collection).snapshots(),
        builder: (context, snapshot) {
          String count = snapshot.hasData ? snapshot.data!.docs.length.toString() : "...";
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(count, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
                CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: const Color(0xff45a182)),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}