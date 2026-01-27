import 'package:flutter/material.dart';

class AdminViewAttendancePage extends StatelessWidget {
  const AdminViewAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // SIDEBAR
          _AdminSidebar(),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                _TopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FiltersBar(),
                        const SizedBox(height: 24),
                        _AttendanceTable(),
                        const SizedBox(height: 24),
                        _SummaryCards(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= SIDEBAR ================= */

class _AdminSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.school, color: Colors.teal),
            title: const Text(
              "SMS Admin",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("Salary Management"),
          ),
          const Divider(),

          _sideItem(Icons.dashboard, "Dashboard"),
          _sideItem(Icons.people, "Manage Faculty"),
          _sideItem(Icons.assignment_turned_in, "View Attendance", active: true),
          _sideItem(Icons.payments, "Salary Reports"),
          const Spacer(),
          const Divider(),
          _sideItem(Icons.logout, "Logout", danger: true),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sideItem(IconData icon, String title,
      {bool active = false, bool danger = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.teal.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: danger
              ? Colors.red
              : active
              ? Colors.teal
              : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: danger ? Colors.red : Colors.black87,
          ),
        ),
      ),
    );
  }
}

/* ================= TOP HEADER ================= */

class _TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffe5e7eb))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Faculty Attendance Log",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: const [
              Icon(Icons.circle, color: Colors.green, size: 10),
              SizedBox(width: 8),
              Text("System Online"),
              SizedBox(width: 24),
              CircleAvatar(
                radius: 16,
                child: Text("AD"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= FILTER BAR ================= */

class _FiltersBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _dropdown("Month", ["October 2023"]),
            const SizedBox(width: 16),
            _dropdown("Faculty", ["All Faculty"]),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text("Export CSV"),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Log Attendance"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        DropdownButton<String>(
          value: items.first,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}

/* ================= ATTENDANCE TABLE ================= */

class _AttendanceTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: DataTable(
        columns: const [
          DataColumn(label: Text("#")),
          DataColumn(label: Text("Faculty Name")),
          DataColumn(label: Text("Date")),
          DataColumn(label: Text("Subject")),
          DataColumn(label: Text("Lectures")),
          DataColumn(label: Text("Status")),
        ],
        rows: [
          _row("001", "Dr. Alan Grant", "Oct 12, 2023", "Paleontology 101", "2",
              Colors.green, "Verified"),
          _row("002", "Prof. Ellie Sattler", "Oct 12, 2023",
              "Paleobotany Advanced", "1", Colors.green, "Verified"),
          _row("003", "Dr. Ian Malcolm", "Oct 11, 2023",
              "Chaos Theory Seminar", "3", Colors.orange, "Pending"),
          _row("004", "John Hammond", "Oct 10, 2023",
              "Ethics in Genetics", "1", Colors.green, "Verified"),
        ],
      ),
    );
  }

  DataRow _row(String id, String name, String date, String subject,
      String lectures, Color color, String status) {
    return DataRow(cells: [
      DataCell(Text(id)),
      DataCell(Text(name)),
      DataCell(Text(date)),
      DataCell(Text(subject)),
      DataCell(Text(lectures)),
      DataCell(
        Chip(
          label: Text(status),
          backgroundColor: color.withOpacity(0.15),
          labelStyle: TextStyle(color: color),
        ),
      ),
    ]);
  }
}

/* ================= SUMMARY CARDS ================= */

class _SummaryCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _card(Icons.analytics, "Total Lectures", "412", Colors.blue),
        _card(Icons.check_circle, "Verified", "94%", Colors.green),
        _card(Icons.pending, "Pending Review", "24", Colors.orange),
      ],
    );
  }

  Widget _card(IconData icon, String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(right: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                      const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
