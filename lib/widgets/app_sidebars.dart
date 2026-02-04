import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ================= ADMIN SIDEBAR =================
class AdminSidebar extends StatelessWidget {
  final String activeRoute;

  const AdminSidebar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader("College SMS", "ADMIN PANEL"),
          const Divider(),
          _SidebarItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            route: '/admin/dashboard',
            isActive: activeRoute == '/admin/dashboard',
          ),
          _SidebarItem(
            icon: Icons.person_add,
            title: "Add Faculty",
            route: '/admin/add-faculty',
            isActive: activeRoute == '/admin/add-faculty',
          ),
          _SidebarItem(
            icon: Icons.groups,
            title: "View Faculty",
            route: '/admin/view-faculty',
            isActive: activeRoute == '/admin/view-faculty',
          ),
          _SidebarItem(
            icon: Icons.checklist,
            title: "View Attendance",
            route: '/admin/view-attendance',
            isActive: activeRoute == '/admin/view-attendance',
          ),
          _SidebarItem(
            icon: Icons.calculate,
            title: "Calculate Salary",
            route: '/admin/calculate-salary',
            isActive: activeRoute == '/admin/calculate-salary',
          ),
          const Spacer(),
          const Divider(),
          _LogoutItem(),
        ],
      ),
    );
  }
}

// ================= FACULTY SIDEBAR =================
class FacultySidebar extends StatelessWidget {
  final String activeRoute;

  const FacultySidebar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader("Faculty Portal", "TEACHER PANEL"),
          const Divider(),
          _SidebarItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            route: '/faculty/dashboard',
            isActive: activeRoute == '/faculty/dashboard',
          ),
          _SidebarItem(
            icon: Icons.calendar_today,
            title: "Add Attendance",
            route: '/faculty/add-attendance',
            isActive: activeRoute == '/faculty/add-attendance',
          ),
          _SidebarItem(
            icon: Icons.payments,
            title: "Salary History",
            route: '/faculty/salary-history',
            isActive: activeRoute == '/faculty/salary-history',
          ),
          // Add more faculty pages here if needed
          const Spacer(),
          const Divider(),
          _LogoutItem(),
        ],
      ),
    );
  }
}

// ================= HELPER WIDGETS =================

Widget _buildHeader(String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffe6f4ea),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.school, color: Color(0xff45a182), size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.0)),
          ],
        ),
      ],
    ),
  );
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool isActive;

  const _SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff45a182).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xff45a182) : Colors.grey[600],
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xff45a182) : Colors.grey[800],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          if (!isActive) Navigator.pushReplacementNamed(context, route);
        },
      ),
    );
  }
}

class _LogoutItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) Navigator.pushReplacementNamed(context, '/');
        },
      ),
    );
  }
}