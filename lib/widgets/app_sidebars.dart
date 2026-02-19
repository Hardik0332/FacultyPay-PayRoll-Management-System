import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; // To access the Dark Mode toggle

class AdminSidebar extends StatelessWidget {
  final String activeRoute;
  const AdminSidebar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 260,
      color: theme.cardColor,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, size: 32, color: theme.primaryColor),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("FacultyPay", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("ADMIN PANEL", style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey)),
                ],
              )
            ],
          ),
          const SizedBox(height: 40),

          _buildNavItem(context, Icons.dashboard, "Dashboard", '/admin/dashboard'),
          _buildNavItem(context, Icons.person_add, "Add Faculty", '/admin/add-faculty'),
          _buildNavItem(context, Icons.people, "View Faculty", '/admin/view-faculty'),
          _buildNavItem(context, Icons.checklist, "View Attendance", '/admin/view-attendance'),
          _buildNavItem(context, Icons.calculate, "Calculate Salary", '/admin/calculate-salary'),
          _buildNavItem(context, Icons.print, "Reports", '/admin/reports'),

          const Spacer(),

          // Dark Mode Toggle
          ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, child) {
                final isDark = currentMode == ThemeMode.dark;
                return ListTile(
                  leading: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.grey.shade600),
                  title: Text(isDark ? "Light Mode" : "Dark Mode", style: const TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                  },
                );
              }
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String title, String route) {
    bool isActive = activeRoute == route;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? theme.primaryColor : Colors.grey.shade600),
        title: Text(title, style: TextStyle(color: isActive ? theme.primaryColor : Colors.grey.shade600, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        onTap: () {
          // If we aren't already on this page, jump to it instantly without animations
          if (!isActive) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }
}

class FacultySidebar extends StatelessWidget {
  final String activeRoute;
  const FacultySidebar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      color: theme.cardColor,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, size: 32, color: theme.primaryColor),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("FacultyPay", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("TEACHER PANEL", style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey)),
                ],
              )
            ],
          ),
          const SizedBox(height: 40),

          _buildNavItem(context, Icons.dashboard, "Dashboard", '/faculty/dashboard'),
          _buildNavItem(context, Icons.calendar_today, "Add Attendance", '/faculty/add-attendance'),
          _buildNavItem(context, Icons.account_balance_wallet, "Salary History", '/faculty/salary-history'),

          const Spacer(),
          ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, child) {
                final isDark = currentMode == ThemeMode.dark;
                return ListTile(
                  leading: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.grey.shade600),
                  title: Text(isDark ? "Light Mode" : "Dark Mode", style: const TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
                );
              }
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String title, String route) {
    bool isActive = activeRoute == route;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? theme.primaryColor : Colors.grey.shade600),
        title: Text(title, style: TextStyle(color: isActive ? theme.primaryColor : Colors.grey.shade600, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        onTap: () {
          if (!isActive) Navigator.pushReplacementNamed(context, route);
        },
      ),
    );
  }
}