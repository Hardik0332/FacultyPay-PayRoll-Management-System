import 'package:flutter/material.dart';

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 240,
            color: Colors.white,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Salary Mgmt",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Faculty Portal v1.0",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                _sideItem(Icons.dashboard, "Dashboard", true),
                _sideItem(Icons.calendar_month, "Attendance", false,
                    onTap: () => Navigator.pushNamed(context, '/attendance')),
                _sideItem(Icons.payments, "Salary History", false),
                const Spacer(),
                _sideItem(Icons.logout, "Logout", false,
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/')),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dashboard",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 4),
                                Text(
                                  "Welcome back, Dr. Smith. Here is your summary for October 2023.",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              "Last login: Oct 24, 09:30 AM",
                              style:
                              TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // SUMMARY CARDS
                        Row(
                          children: [
                            _card("HOURLY RATE", "\$50.00"),
                            _card("LECTURES (OCT)", "12"),
                            _card("TOTAL SALARY", "\$600.00"),
                          ],
                        ),

                        const SizedBox(height: 32),

                        const Text("Recent Lectures",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        // TABLE
                        Container(
                          color: Colors.white,
                          child: DataTable(
                            headingRowHeight: 44,
                            dataRowHeight: 48,
                            columns: const [
                              DataColumn(label: Text("DATE")),
                              DataColumn(label: Text("SUBJECT")),
                              DataColumn(label: Text("DURATION")),
                              DataColumn(label: Text("EARNINGS")),
                              DataColumn(label: Text("STATUS")),
                            ],
                            rows: const [
                              DataRow(cells: [
                                DataCell(Text("Oct 24")),
                                DataCell(
                                    Text("CS101: Intro to Programming")),
                                DataCell(Text("1.5 hrs")),
                                DataCell(Text("\$75.00")),
                                DataCell(_StatusBadge("Verified", true)),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("Oct 18")),
                                DataCell(Text("CS305: Algorithms")),
                                DataCell(Text("1.0 hr")),
                                DataCell(Text("\$50.00")),
                                DataCell(_StatusBadge("Pending", false)),
                              ]),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Center(
                          child: Text(
                            "System v1.0.2 • Need help? Contact Admin",
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sideItem(IconData icon, String text, bool active,
      {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: active ? const Color(0xffe6f4ea) : null,
        border: Border(
          left: BorderSide(
            color: active ? const Color(0xff45a182) : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 20),
        title: Text(text, style: const TextStyle(fontSize: 13)),
        onTap: onTap,
      ),
    );
  }

  static Widget _card(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(value,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final bool verified;

  const _StatusBadge(this.text, this.verified);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: verified
            ? const Color(0xffe6f4ea)
            : const Color(0xfffff4e5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: verified ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
