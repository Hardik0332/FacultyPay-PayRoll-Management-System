import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_sidebars.dart'; // ✅ Import Shared Sidebar

class AdminViewAttendancePage extends StatelessWidget {
  const AdminViewAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // ✅ USE SHARED SIDEBAR
          const AdminSidebar(activeRoute: '/admin/view-attendance'),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                _TopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Attendance Verification", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),

                        // REAL FIRESTORE TABLE
                        const ExpandedAttendanceTable(),
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

/* ================= REAL DATA TABLE ================= */

class ExpandedAttendanceTable extends StatelessWidget {
  const ExpandedAttendanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .orderBy('submittedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error loading data");
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text("No attendance records found")),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
            columns: const [
              DataColumn(label: Text("Faculty Name")),
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Subject")),
              DataColumn(label: Text("Lectures")),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Actions")),
            ],
            rows: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final uid = data['uid'] ?? '';
              final dateVal = data['date'];
              DateTime date = (dateVal is Timestamp) ? dateVal.toDate() : DateTime.now();
              final status = data['status'] ?? 'Pending';

              return DataRow(cells: [
                // 1. Fetch Name from Users Collection
                DataCell(
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                    builder: (context, userSnap) {
                      if (!userSnap.hasData) return const Text("Loading...");
                      return Text(userSnap.data?.get('name') ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold));
                    },
                  ),
                ),
                DataCell(Text(DateFormat('MMM dd, yyyy').format(date))),
                DataCell(Text(data['subject'] ?? '-')),
                DataCell(Text(data['lectures'].toString())),

                // Status Badge
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == 'Verified' ? Colors.green.withOpacity(0.1) : (status == 'Paid' ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                          color: status == 'Verified' ? Colors.green : (status == 'Paid' ? Colors.blue : Colors.orange),
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                  ),
                ),

                // Action Button (Verify)
                DataCell(
                  status == 'Pending'
                      ? IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    tooltip: "Mark Verified",
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('attendance').doc(doc.id).update({
                        'status': 'Verified'
                      });
                    },
                  )
                      : const Icon(Icons.check, color: Colors.grey, size: 18),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}

class _TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Faculty Attendance Log", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CircleAvatar(radius: 18, backgroundColor: Color(0xffe6f4ea), child: Text("A", style: TextStyle(color: Color(0xff45a182), fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}