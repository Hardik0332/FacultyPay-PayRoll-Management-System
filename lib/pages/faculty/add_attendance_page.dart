import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_sidebars.dart'; // ✅ Shared Sidebar

class FacultyAddAttendancePage extends StatefulWidget {
  const FacultyAddAttendancePage({super.key});

  @override
  State<FacultyAddAttendancePage> createState() =>
      _FacultyAddAttendancePageState();
}

class _FacultyAddAttendancePageState extends State<FacultyAddAttendancePage> {
  DateTime? selectedDate;
  bool isLoading = false;

  // ✅ DATA LISTS (You can change these easily)
  final List<String> classOptions = ['BSC.CS', 'BSC.IT', 'BCA', 'M.Sc CS', 'B.Tech'];
  final List<String> subjectOptions = [
    'Java Programming',
    'Data Structures',
    'Python',
    'Web Development',
    'Database (DBMS)',
    'Networking',
    'Mathematics'
  ];

  // ✅ DYNAMIC LIST OF LECTURES
  // We start with one empty lecture
  List<Map<String, String?>> lectureEntries = [
    {'class': null, 'subject': null}
  ];

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

  void _addLectureRow() {
    setState(() {
      lectureEntries.add({'class': null, 'subject': null});
    });
  }

  void _removeLectureRow(int index) {
    if (lectureEntries.length > 1) {
      setState(() {
        lectureEntries.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must add at least one lecture.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          const FacultySidebar(activeRoute: '/faculty/add-attendance'),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                // Header
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

                        // ✅ NEW DYNAMIC FORM
                        _buildDynamicForm(),

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

  Widget _pageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Record Daily Attendance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Text("Select your class and subject for each lecture conducted today.", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildDynamicForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. DATE PICKER (Common for all)
          const Text("Date of Lectures *", style: TextStyle(fontWeight: FontWeight.bold)),
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

          const Divider(),
          const SizedBox(height: 16),

          // 2. DYNAMIC LIST OF LECTURES
          const Text("Lecture Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lectureEntries.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildLectureRow(index);
            },
          ),

          const SizedBox(height: 24),

          // 3. ACTION BUTTONS (Add Row & Submit)
          Row(
            children: [
              TextButton.icon(
                onPressed: _addLectureRow,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text("Add Another Lecture"),
                style: TextButton.styleFrom(foregroundColor: const Color(0xff45a182)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff45a182),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send, size: 20),
                label: const Text("Submit All", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: isLoading ? null : _submitAllAttendance,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Individual Row for Class & Subject
  Widget _buildLectureRow(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fa),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Lecture Number
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey.shade400,
            child: Text("${index + 1}", style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          const SizedBox(width: 16),

          // Class Dropdown
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: lectureEntries[index]['class'],
              decoration: const InputDecoration(
                labelText: "Class",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
              ),
              items: classOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => lectureEntries[index]['class'] = val),
            ),
          ),
          const SizedBox(width: 12),

          // Subject Dropdown
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: lectureEntries[index]['subject'],
              decoration: const InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
              ),
              items: subjectOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => lectureEntries[index]['subject'] = val),
            ),
          ),

          // Delete Button (Only if more than 1 row)
          if (lectureEntries.length > 1)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeLectureRow(index),
            ),
        ],
      ),
    );
  }

  Future<void> _submitAllAttendance() async {
    // Validation
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a date")));
      return;
    }

    for (var entry in lectureEntries) {
      if (entry['class'] == null || entry['subject'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select Class and Subject for all lectures")));
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final batch = FirebaseFirestore.instance.batch();
        final collection = FirebaseFirestore.instance.collection('attendance');

        // Loop through each row and create a separate document
        for (var entry in lectureEntries) {
          final docRef = collection.doc(); // Create new ID

          batch.set(docRef, {
            'uid': user.uid,
            'date': selectedDate,
            'lectures': 1, // IMPORTANT: Each row counts as 1 lecture for calculation
            'subject': "${entry['class']} - ${entry['subject']}", // Combine them so Admin sees both
            'class': entry['class'],   // Storing separately just in case
            'topic': entry['subject'], // Storing separately just in case
            'status': 'Pending',
            'submittedAt': Timestamp.now(),
          });
        }

        await batch.commit();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successfully submitted ${lectureEntries.length} lectures!")),
          );

          // Reset Form
          setState(() {
            selectedDate = null;
            lectureEntries = [{'class': null, 'subject': null}];
          });
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// RECENT ENTRIES TABLE (Unchanged)
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
                    subtitle: Text("${data['lectures']} Lecture • ${data['subject'] ?? ''}"),
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