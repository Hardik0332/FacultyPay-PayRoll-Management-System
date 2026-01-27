import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // ================= SIDEBAR =================
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "College SMS",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff45a182)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "SALARY MGMT SYSTEM",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                _sideItem(
                    icon: Icons.dashboard,
                    title: "Dashboard",
                    active: true),
                _sideItem(
                    icon: Icons.person_add, title: "Add Faculty"),
                _sideItem(
                    icon: Icons.checklist, title: "View Attendance"),
                _sideItem(
                    icon: Icons.calculate, title: "Calculate Salary"),

                const Spacer(),
                const Divider(),
                _sideItem(
                    icon: Icons.logout,
                    title: "Logout",
                    color: Colors.red),
                const SizedBox(height: 12),

                // Admin info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                        const Color(0xff45a182).withOpacity(0.2),
                        child: const Text("AD",
                            style: TextStyle(
                                color: Color(0xff45a182),
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Admin User",
                              style: TextStyle(fontSize: 13)),
                          Text("admin@college.edu",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // ================= MAIN CONTENT =================
          Expanded(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Admin Dashboard",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text("Logout"),
                      )
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats cards
                        Row(
                          children: const [
                            Expanded(
                              child: _StatCard(
                                title: "Faculty Members",
                                value: "12",
                                subtitle:
                                "Total Visiting Faculty active this semester",
                                color: Color(0xff45a182),
                                icon: Icons.group,
                                progress: 0.45,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                title: "Lectures Recorded",
                                value: "145",
                                subtitle:
                                "Total sessions logged in the system",
                                color: Colors.purple,
                                icon: Icons.library_books,
                                progress: 0.72,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Quick Actions
                        const Text(
                          "Quick Actions",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: const [
                            _QuickAction(
                                icon: Icons.add_circle, title: "New Entry"),
                            SizedBox(width: 16),
                            _QuickAction(
                                icon: Icons.print, title: "Print Report"),
                          ],
                        ),

                        const SizedBox(height: 40),
                        const Divider(),

                        // Footer
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "© 2023 College SMS Project. All rights reserved.",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              Row(
                                children: [
                                  Text("Privacy Policy",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey)),
                                  SizedBox(width: 16),
                                  Text("Support",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= COMPONENTS =================

Widget _sideItem(
    {required IconData icon,
      required String title,
      bool active = false,
      Color? color}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: active ? const Color(0xffe6f4ea) : null,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      leading: Icon(icon,
          size: 20,
          color: color ??
              (active ? const Color(0xff45a182) : Colors.grey)),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            color: color ??
                (active ? const Color(0xff45a182) : Colors.grey)),
      ),
      onTap: () {},
    ),
  );
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;
  final double progress;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(),
                      style:
                      const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color),
              )
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: Colors.grey.shade200,
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;

  const _QuickAction({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.grey),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
