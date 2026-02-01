import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_sidebars.dart'; // ✅ Import Shared Sidebar

class FacultyAddAttendancePage extends StatefulWidget {
  const FacultyAddAttendancePage({super.key});

  @override
  State<FacultyAddAttendancePage> createState() =>
      _FacultyAddAttendancePageState();
}

class _FacultyAddAttendancePageState extends State<FacultyAddAttendancePage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  final TextEditingController lecturesController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  bool isLoading = false;

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
      // No Drawer, No AppBar -> We build a custom layout
      body: Row(
        children: [
          // ✅ USE SHARED SIDEBAR
          const FacultySidebar(activeRoute: '/faculty/add-attendance'),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                // Custom Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: const [
                      Text("Add Attendance", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Spacer(),
                      CircleAvatar(radius: 18, backgroundColor: Color(0xffe6f4ea), child: Icon(Icons.person, size: 20, color: Color(0xff45a182))),
                    ],
                  ),
                ),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _pageHeader(),
                        const SizedBox(height: 30),
                        _attendanceForm(),
                        const SizedBox(height: 40),
                        _recentEntries(),
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

  /// PAGE HEADER
  Widget _pageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Record Daily Attendance",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Text(
          "Enter details for the lectures conducted today. These will be sent to Admin for verification.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  /// FORM CARD
  Widget _attendanceForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            const Text("Date of Lecture *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      selectedDate == null
                          ? "Select Date"
                          : DateFormat("dd MMM yyyy").format(selectedDate!),
                      style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lectures Input
            const Text("Number of Lectures *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: lecturesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "e.g. 2",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Required" : null,
            ),
            const SizedBox(height: 24),

            // Subject Input
            const Text("Subject / Topic", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: "Brief description (Optional)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff45a182),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send, size: 20),
                label: const Text("Submit Attendance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                onPressed: isLoading ? null : () async {
                  if (_formKey.currentState!.validate() && selectedDate != null) {
                    setState(() => isLoading = true);

                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance.collection('attendance').add({
                          'uid': user.uid,
                          'date': selectedDate,
                          'lectures': int.parse(lecturesController.text),
                          'subject': subjectController.text,
                          'status': 'Pending',
                          'submittedAt': Timestamp.now(),
                        });

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Attendance Submitted Successfully")),
                          );
                          lecturesController.clear();
                          subjectController.clear();
                          setState(() => selectedDate = null);
                        }
                      }
                    } catch (e) {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                    } finally {
                      if (mounted) setState(() => isLoading = false);
                    }
                  } else if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a date")));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// RECENT ENTRIES TABLE
  Widget _recentEntries() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Submissions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('attendance')
              .where('uid', isEqualTo: user.uid)
              .orderBy('submittedAt', descending: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            if (snapshot.data!.docs.isEmpty) return const Text("No recent entries.");

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (c, i) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final date = (data['date'] as Timestamp).toDate();
                  final status = data['status'] ?? 'Pending';

                  Color color = Colors.orange;
                  if (status == 'Verified') color = Colors.green;
                  if (status == 'Paid') color = Colors.blue;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    title: Text(DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text("${data['lectures']} Lectures • ${data['subject'] ?? ''}"),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}