import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_sidebars.dart'; // Import the new sidebar

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // ✅ USE THE SHARED SIDEBAR
          const FacultySidebar(activeRoute: '/faculty/dashboard'),

          // MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(user),
                  const SizedBox(height: 32),
                  _buildStatsRow(user),
                  const SizedBox(height: 32),
                  const Text("Recent Attendance History",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRecentActivityTable(user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        String name = "Faculty Member";
        if (snapshot.hasData && snapshot.data!.exists) {
          name = snapshot.data!['name'] ?? "Faculty Member";
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome back, $name",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                const Text("Here is your performance summary for this month.",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xffe6f4ea),
              child: Icon(Icons.person, color: Color(0xff45a182)),
            )
          ],
        );
      },
    );
  }

  Widget _buildStatsRow(User? user) {
    if (user == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .where('uid', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();

        int totalLectures = 0;
        int verifiedLectures = 0;

        for (var doc in snapshot.data!.docs) {
          totalLectures += (doc['lectures'] as int);
          if (doc['status'] == 'Verified' || doc['status'] == 'Paid') {
            verifiedLectures += (doc['lectures'] as int);
          }
        }

        // Fetch Hourly Rate separately to calculate earnings
        return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, userSnap) {
              double rate = 0;
              if (userSnap.hasData && userSnap.data!.exists) {
                rate = (userSnap.data!['hourlyRate'] ?? 0).toDouble();
              }
              double earnings = verifiedLectures * rate;

              return Row(
                children: [
                  _StatCard(
                    title: "Total Earnings",
                    value: "\₹${earnings.toStringAsFixed(2)}",
                    icon: Icons.attach_money,
                    color: const Color(0xff45a182),
                  ),
                  const SizedBox(width: 20),
                  _StatCard(
                    title: "Total Lectures",
                    value: "$totalLectures",
                    icon: Icons.class_outlined,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 20),
                  _StatCard(
                    title: "Hourly Rate",
                    value: "\₹${rate.toStringAsFixed(0)}",
                    icon: Icons.access_time,
                    color: Colors.orangeAccent,
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Widget _buildRecentActivityTable(User? user) {
    if (user == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .where('uid', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Text("No attendance records found. Start by adding one!", style: TextStyle(color: Colors.grey)),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: DataTable(
            columnSpacing: 20,
            horizontalMargin: 24,
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
            columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Subject")),
              DataColumn(label: Text("Lectures")),
              DataColumn(label: Text("Status")),
            ],
            rows: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              DateTime date = (data['date'] as Timestamp).toDate();
              String status = data['status'] ?? 'Pending';
              Color statusColor = status == 'Verified' || status == 'Paid' ? Colors.green : Colors.orange;

              return DataRow(cells: [
                DataCell(Text(DateFormat('MMM dd, yyyy').format(date))),
                DataCell(Text(data['subject'] ?? '-')),
                DataCell(Text(data['lectures'].toString())),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}