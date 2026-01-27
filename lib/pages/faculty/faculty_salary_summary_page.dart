import 'package:flutter/material.dart';

class FacultySalarySummaryPage extends StatelessWidget {
  const FacultySalarySummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F7),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE0F2EC),
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Dr. Jane Smith",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Visiting Professor",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                _sideItem(Icons.dashboard, "Dashboard"),
                _sideItem(Icons.person, "My Profile"),
                _sideItem(Icons.payments, "Salary History", active: true),
                _sideItem(Icons.support, "Support"),

                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Salary Summary",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Academic Year 2023 - 2024",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download),
                        label: const Text("Download CSV"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF45A182),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Summary Cards
                  Row(
                    children: [
                      _summaryCard(
                        title: "Total Earned YTD",
                        value: "\$8,750.00",
                        footer: "75% of contract fulfilled",
                        color: Colors.green,
                      ),
                      const SizedBox(width: 20),
                      _summaryCard(
                        title: "Pending Payments",
                        value: "\$400.00",
                        footer: "Action Required: None",
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Monthly Breakdown
                  const Text(
                    "Monthly Breakdown",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _salaryRow("October 2023", "12 hrs", "\$600.00", "Paid",
                      Colors.green),
                  _salaryRow("November 2023", "15 hrs", "\$750.00",
                      "Processing", Colors.blue),
                  _salaryRow("December 2023", "8 hrs", "\$400.00",
                      "Pending", Colors.orange),
                  _salaryRow("January 2024", "--", "\$0.00", "Future",
                      Colors.grey),

                  const SizedBox(height: 30),

                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF6F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.info, color: Color(0xFF45A182)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Payments for hourly work are processed on the 15th of the following month. "
                                "If you notice any discrepancy, contact the department within 5 business days.",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Item
  static Widget _sideItem(IconData icon, String title,
      {bool active = false}) {
    return ListTile(
      leading: Icon(icon,
          color: active ? const Color(0xFF45A182) : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          color: active ? const Color(0xFF45A182) : Colors.black,
        ),
      ),
    );
  }

  // Summary Card
  static Widget _summaryCard({
    required String title,
    required String value,
    required String footer,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              footer,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  // Salary Row
  static Widget _salaryRow(
      String month,
      String hours,
      String amount,
      String status,
      Color statusColor,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(hours),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
