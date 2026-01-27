import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyAddAttendancePage extends StatefulWidget {
  const FacultyAddAttendancePage({Key? key}) : super(key: key);

  @override
  State<FacultyAddAttendancePage> createState() =>
      _FacultyAddAttendancePageState();
}

class _FacultyAddAttendancePageState extends State<FacultyAddAttendancePage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  final TextEditingController lecturesController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      drawer: _facultyDrawer(),
      appBar: AppBar(
        title: const Text("Add Attendance"),
        backgroundColor: const Color(0xff45a182),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pageHeader(),
            const SizedBox(height: 20),
            _attendanceForm(),
            const SizedBox(height: 30),
            _recentEntries(),
          ],
        ),
      ),
    );
  }

  /// PAGE HEADER
  Widget _pageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Record Daily Attendance",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "Enter details for the lectures conducted today.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  /// FORM CARD
  Widget _attendanceForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// DATE
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Date of Lecture *",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    selectedDate == null
                        ? "Select date"
                        : DateFormat("dd MMM yyyy").format(selectedDate!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// LECTURES
              TextFormField(
                controller: lecturesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Lectures *",
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// SUBJECT
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject / Topic (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              /// SUBMIT
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff45a182),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text("Submit Attendance"),
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedDate != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Attendance Submitted"),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// RECENT ENTRIES TABLE
  Widget _recentEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Entries",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Lectures")),
              DataColumn(label: Text("Status")),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text("Oct 24, 2023")),
                DataCell(Text("2")),
                DataCell(_StatusChip("Approved", Colors.green)),
              ]),
              DataRow(cells: [
                DataCell(Text("Oct 23, 2023")),
                DataCell(Text("1")),
                DataCell(_StatusChip("Pending", Colors.orange)),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  /// DRAWER
  Drawer _facultyDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xff45a182)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 26, child: Icon(Icons.person)),
                SizedBox(height: 10),
                Text("Dr. Alex Morgan",
                    style: TextStyle(color: Colors.white)),
                Text("Visiting Professor",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _drawerItem(Icons.dashboard, "Dashboard"),
          _drawerItem(Icons.calendar_today, "Add Attendance"),
          _drawerItem(Icons.history, "View History"),
          _drawerItem(Icons.payments, "Salary Slips"),
          const Spacer(),
          _drawerItem(Icons.logout, "Sign Out", isLogout: true),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : null),
      title: Text(title,
          style: TextStyle(color: isLogout ? Colors.red : null)),
      onTap: () {},
    );
  }
}

/// STATUS CHIP
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.15),
    );
  }
}
