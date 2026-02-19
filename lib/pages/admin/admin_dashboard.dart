import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_sidebars.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    // ✅ 1. Grab the theme for dynamic styling
    final theme = Theme.of(context);

    return Scaffold(
      // ✅ 2. Background color is now handled automatically by the theme in main.dart
      appBar: isDesktop
          ? null
          : AppBar(
        title: const Text("Admin Panel"),
        elevation: 0,
      ),
      drawer: isDesktop
          ? null
          : const Drawer(
        child: AdminSidebar(activeRoute: '/admin/dashboard'),
      ),
      body: Row(
        children: [
          if (isDesktop) const AdminSidebar(activeRoute: '/admin/dashboard'),

          // MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 32 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Admin Dashboard", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),

                  // REAL-TIME STATS RESPONSIVE
                  if (isDesktop)
                    Row(
                      children: [
                        Expanded(
                            child: _StatCard(
                                title: "Faculty Members",
                                queryStream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'faculty').snapshots(), // ✅ Filter applied here
                                color: const Color(0xff45a182),
                                icon: Icons.group
                            )
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _StatCard(
                                title: "Attendance Records",
                                queryStream: FirebaseFirestore.instance.collection('attendance').snapshots(), // ✅ Unfiltered stream
                                color: Colors.purple,
                                icon: Icons.library_books
                            )
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _StatCard(
                            title: "Faculty Members",
                            queryStream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'faculty').snapshots(), // ✅ Filter applied here
                            color: const Color(0xff45a182),
                            icon: Icons.group
                        ),
                        const SizedBox(height: 16),
                        _StatCard(
                            title: "Attendance Records",
                            queryStream: FirebaseFirestore.instance.collection('attendance').snapshots(), // ✅ Unfiltered stream
                            color: Colors.purple,
                            icon: Icons.library_books
                        ),
                      ],
                    ),

                  const SizedBox(height: 32),
                  const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),

                  // QUICK ACTIONS RESPONSIVE
                  if (isDesktop)
                    Row(
                      children: [
                        Expanded(child: _QuickAction(icon: Icons.person_add, title: "Add New Faculty", onTap: () => Navigator.pushReplacementNamed(context, '/admin/add-faculty'))),
                        const SizedBox(width: 16),
                        Expanded(child: _QuickAction(icon: Icons.check_circle, title: "Verify Attendance", onTap: () => Navigator.pushReplacementNamed(context, '/admin/view-attendance'))),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _QuickAction(icon: Icons.person_add, title: "Add New Faculty", onTap: () => Navigator.pushReplacementNamed(context, '/admin/add-faculty')),
                        const SizedBox(height: 16),
                        _QuickAction(icon: Icons.check_circle, title: "Verify Attendance", onTap: () => Navigator.pushReplacementNamed(context, '/admin/view-attendance')),
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

class _StatCard extends StatelessWidget {
  final String title;
  final Stream<QuerySnapshot> queryStream; // ✅ Accepts a Stream instead of a String collection name
  final Color color;
  final IconData icon;

  const _StatCard({required this.title, required this.queryStream, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    // ✅ Use theme cardColor
    final theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: queryStream, // ✅ Use the passed stream
      builder: (context, snapshot) {
        String count = snapshot.hasData ? snapshot.data!.docs.length.toString() : "...";
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor, // ✅ Dynamic Card Color
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(count, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
            ],
          ),
        );
      },
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
    // ✅ Use theme cardColor
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor, // ✅ Dynamic Card Color
          border: Border.all(color: Colors.grey.withOpacity(0.2)), // Subtle border for dark mode
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: const Color(0xff45a182)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}