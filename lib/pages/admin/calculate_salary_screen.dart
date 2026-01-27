import 'package:flutter/material.dart';

class CalculateSalaryScreen extends StatelessWidget {
  const CalculateSalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // ================= SIDEBAR =================
          Container(
            width: 240,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 24),
                ListTile(
                  leading: Icon(Icons.school, color: Color(0xff45a182)),
                  title: const Text(
                    'College SMS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Admin Panel'),
                ),
                const Divider(),
                _sideItem(Icons.dashboard, 'Dashboard'),
                _sideItem(Icons.group, 'Manage Faculty'),
                _sideItem(Icons.calculate, 'Calculate Salary', active: true),
                _sideItem(Icons.history, 'Payment History'),
                _sideItem(Icons.settings, 'Settings'),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(child: Text('A')),
                  title: const Text('Admin User'),
                  subtitle: const Text('Log out'),
                ),
              ],
            ),
          ),

          // ================= MAIN CONTENT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Salary Calculation',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Review and process faculty payments'),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            label: const Text('Export CSV'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff45a182),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.article),
                            label: const Text('Generate Report'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Filters
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      _dropdownBox('October 2023'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search faculty...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Faculty Name')),
                            DataColumn(label: Text('Department')),
                            DataColumn(label: Text('Lectures')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: [
                            _row(
                              name: 'Prof. John Doe',
                              dept: 'Computer Science',
                              lectures: '12',
                              amount: '\$1,200',
                              status: 'Pending',
                            ),
                            _row(
                              name: 'Dr. Jane Smith',
                              dept: 'Physics',
                              lectures: '8',
                              amount: '\$800',
                              status: 'Paid',
                            ),
                            _row(
                              name: 'Mr. Alan Turing',
                              dept: 'Mathematics',
                              lectures: '15',
                              amount: '\$1,500',
                              status: 'Pending',
                            ),
                            _row(
                              name: 'Ms. Grace Hopper',
                              dept: 'Computer Science',
                              lectures: '10',
                              amount: '\$1,000',
                              status: 'Paid',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Info Cards
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: const [
                      _InfoCard(
                        icon: Icons.info,
                        title: 'Payment Status',
                        text:
                        'Status updates automatically after confirmation.',
                      ),
                      SizedBox(width: 12),
                      _InfoCard(
                        icon: Icons.calculate,
                        title: 'Lecture Rate',
                        text: 'Default rate is \$100 per lecture.',
                      ),
                      SizedBox(width: 12),
                      _InfoCard(
                        icon: Icons.lock,
                        title: 'Secure Action',
                        text: 'Reports are locked after generation.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  static Widget _sideItem(IconData icon, String text,
      {bool active = false}) {
    return ListTile(
      leading: Icon(icon, color: active ? Color(0xff45a182) : Colors.grey),
      title: Text(
        text,
        style: TextStyle(
          color: active ? Color(0xff45a182) : Colors.black,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  static DataRow _row({
    required String name,
    required String dept,
    required String lectures,
    required String amount,
    required String status,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(dept)),
        DataCell(Text(lectures)),
        DataCell(Text(amount)),
        DataCell(
          Chip(
            label: Text(status),
            backgroundColor:
            status == 'Paid' ? Colors.green.shade100 : Colors.amber.shade100,
          ),
        ),
        DataCell(
          TextButton(
            onPressed: () {},
            child: Text(status == 'Paid' ? 'Receipt' : 'Pay Now'),
          ),
        ),
      ],
    );
  }

  static Widget _dropdownBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Color(0xff45a182)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(text, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
