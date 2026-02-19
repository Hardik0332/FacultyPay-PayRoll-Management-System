import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_sidebars.dart';
import '../../services/report_service.dart';
import '../../services/receipt_service.dart';

class CalculateSalaryScreen extends StatelessWidget {
  const CalculateSalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    // ✅ 1. Grab theme for dynamic colors
    final theme = Theme.of(context);

    return Scaffold(
      // ✅ 2. Background inherited from main.dart
      appBar: isDesktop
          ? null
          : AppBar(
        title: const Text("Calculate Salary"),
        elevation: 0,
      ),
      drawer: isDesktop
          ? null
          : const Drawer(
        child: AdminSidebar(activeRoute: '/admin/calculate-salary'),
      ),
      body: Row(
        children: [
          // ✅ USE SHARED SIDEBAR
          if (isDesktop) const AdminSidebar(activeRoute: '/admin/calculate-salary'),

          // MAIN CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                if (isDesktop)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    color: theme.cardColor, // ✅ Dynamic Header Background
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Salary Calculation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Process payments for verified lectures', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                if (isDesktop) const SizedBox(height: 20),

                // FACULTY SALARY TABLE
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 32 : 16),
                    child: StreamBuilder<QuerySnapshot>(
                      // 1. Get All Faculty Members
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'faculty')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No faculty members found."));
                        }

                        final facultyDocs = snapshot.data!.docs;

                        return Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor, // ✅ Dynamic Table Background
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                          ),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(0),
                            itemCount: facultyDocs.length,
                            separatorBuilder: (c, i) => Divider(height: 1, color: Colors.grey.withOpacity(0.2)), // ✅ Subtle divider
                            itemBuilder: (context, index) {
                              return _SalaryRow(facultyDoc: facultyDocs[index], isDesktop: isDesktop);
                            },
                          ),
                        );
                      },
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

// ================= INDIVIDUAL ROW COMPONENT =================
class _SalaryRow extends StatelessWidget {
  final QueryDocumentSnapshot facultyDoc;
  final bool isDesktop;

  const _SalaryRow({required this.facultyDoc, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ✅ Theme context
    final data = facultyDoc.data() as Map<String, dynamic>;
    final String uid = facultyDoc.id;
    final String name = data['name'] ?? 'Unknown';
    final String dept = data['department'] ?? '-';
    // Ensure hourlyRate is treated as double
    final double rate = (data['hourlyRate'] is int)
        ? (data['hourlyRate'] as int).toDouble()
        : (data['hourlyRate'] as double? ?? 0.0);

    // 2. Stream "Verified" attendance for this specific user
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: 'Verified') // Only fetch what is OWED
          .snapshots(),
      builder: (context, attSnapshot) {

        if (attSnapshot.connectionState == ConnectionState.waiting && !attSnapshot.hasData) {
          return const LinearProgressIndicator();
        }

        final docs = attSnapshot.data?.docs ?? [];

        // 3. Calculate Totals
        int totalLectures = 0;
        for (var doc in docs) {
          totalLectures += (doc['lectures'] as int);
        }

        double totalAmount = totalLectures * rate;
        bool isOwed = totalAmount > 0;

        Widget profileCol = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(dept.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        );

        Widget detailsRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$totalLectures Lectures", style: const TextStyle(fontWeight: FontWeight.w500)),
            // ✅ Removed hardcoded Colors.black87 so text appears white in Dark Mode
            Text("₹${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: isOwed ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(isOwed ? "Pending" : "Paid Up", textAlign: TextAlign.center, style: TextStyle(color: isOwed ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        );

        Widget actionBtn = isOwed
            ? ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff45a182)), onPressed: () => _payFaculty(context, uid, docs), child: const Text("Pay Now"))
            : OutlinedButton.icon(icon: const Icon(Icons.print, size: 16), label: const Text("Print"), onPressed: () {
          // ✅ Dynamically grabs the current month for a professional receipt label
          String currentMonthLabel = DateFormat('MMMM yyyy').format(DateTime.now());

          ReceiptService.printReceipt(
            facultyName: name,
            department: dept,
            month: currentMonthLabel,
            totalLectures: totalLectures,
            ratePerLecture: rate,
            totalAmount: totalAmount,
            paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            receiptId: "REC-${DateTime.now().millisecondsSinceEpoch}",
          );
        });

        if (isDesktop) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Expanded(flex: 3, child: profileCol),
                Expanded(flex: 2, child: Text("$totalLectures Lectures", style: const TextStyle(fontWeight: FontWeight.w500))),
                // ✅ Removed hardcoded Colors.black87
                Expanded(flex: 2, child: Text("₹${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Expanded(flex: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: isOwed ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(isOwed ? "Pending" : "Paid Up", textAlign: TextAlign.center, style: TextStyle(color: isOwed ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)))),
                Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: actionBtn)),
              ],
            ),
          );
        } else {
          // Mobile View Stack
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileCol,
                const SizedBox(height: 16),
                detailsRow,
                const SizedBox(height: 16),
                Align(alignment: Alignment.centerRight, child: actionBtn),
              ],
            ),
          );
        }
      },
    );
  }

  // 4. PAY FUNCTION
  Future<void> _payFaculty(BuildContext context, String uid, List<QueryDocumentSnapshot> docs) async {
    bool confirm = await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor, // ✅ Match popup to theme
          title: const Text("Confirm Payment"),
          content: Text("Mark ${docs.length} attendance records as PAID?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Cancel")),
            ElevatedButton(onPressed: () => Navigator.pop(c, true), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff45a182)), child: const Text("Confirm")),
          ],
        )
    ) ?? false;

    if (confirm) {
      final batch = FirebaseFirestore.instance.batch();

      for (var doc in docs) {
        batch.update(doc.reference, {'status': 'Paid'});
      }

      await batch.commit();

      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Processed Successfully")));
      }
    }
  }
}