import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Added for deep linking
import 'package:qr_flutter/qr_flutter.dart'; // ✅ Added for QR code
import '../../widgets/app_sidebars.dart';
import '../../services/receipt_service.dart';

class CalculateSalaryScreen extends StatelessWidget {
  const CalculateSalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final theme = Theme.of(context);

    return Scaffold(
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
          if (isDesktop) const AdminSidebar(activeRoute: '/admin/calculate-salary'),

          // MAIN CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    color: theme.cardColor,
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

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 32 : 16),
                    child: RefreshIndicator(
                      color: theme.primaryColor,
                      backgroundColor: theme.cardColor,
                      onRefresh: () async {
                        await Future.delayed(const Duration(milliseconds: 1200));
                      },
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('role', isEqualTo: 'faculty')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 100),
                                Center(child: Text("No faculty members found."))
                              ],
                            );
                          }

                          final facultyDocs = snapshot.data!.docs;

                          return Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                            ),
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              itemCount: facultyDocs.length,
                              separatorBuilder: (c, i) => Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
                              itemBuilder: (context, index) {
                                return _SalaryRow(facultyDoc: facultyDocs[index], isDesktop: isDesktop);
                              },
                            ),
                          );
                        },
                      ),
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
    final data = facultyDoc.data() as Map<String, dynamic>;
    final String uid = facultyDoc.id;
    final String name = data['name'] ?? 'Unknown';
    final String dept = data['department'] ?? '-';
    final String upiId = data['upiId'] ?? ''; // ✅ Ensure UPI ID is fetched
    final double rate = (data['hourlyRate'] is int)
        ? (data['hourlyRate'] as int).toDouble()
        : (data['hourlyRate'] as double? ?? 0.0);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .where('uid', isEqualTo: uid)
          .where('status', whereIn: ['Verified', 'Paid'])
          .snapshots(),
      builder: (context, attSnapshot) {

        if (attSnapshot.connectionState == ConnectionState.waiting && !attSnapshot.hasData) {
          return const LinearProgressIndicator();
        }

        final docs = attSnapshot.data?.docs ?? [];
        final now = DateTime.now();

        int owedLectures = 0;
        int paidLecturesThisMonth = 0;
        List<QueryDocumentSnapshot> docsToPay = [];
        List<QueryDocumentSnapshot> paidDocsThisMonth = [];

        for (var doc in docs) {
          String status = doc['status'];
          DateTime docDate = (doc['date'] as Timestamp).toDate();

          if (status == 'Verified') {
            owedLectures += (doc['lectures'] as int);
            docsToPay.add(doc);
          } else if (status == 'Paid' && docDate.month == now.month && docDate.year == now.year) {
            paidLecturesThisMonth += (doc['lectures'] as int);
            paidDocsThisMonth.add(doc);
          }
        }

        double owedAmount = owedLectures * rate;
        double paidAmountThisMonth = paidLecturesThisMonth * rate;
        bool isOwed = owedAmount > 0;

        int displayLectures = isOwed ? owedLectures : paidLecturesThisMonth;
        double displayAmount = isOwed ? owedAmount : paidAmountThisMonth;

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
            Text("$displayLectures Lectures", style: const TextStyle(fontWeight: FontWeight.w500)),
            Text("₹${displayAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: isOwed ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(isOwed ? "Pending" : "Paid Up", textAlign: TextAlign.center, style: TextStyle(color: isOwed ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        );

        Widget actionBtn;
        if (isOwed) {
          actionBtn = ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff45a182)),
              // ✅ Pass all parameters safely
              onPressed: () => _payFaculty(context, uid, docsToPay, name, displayAmount, upiId),
              child: const Text("Pay Now")
          );
        } else if (paidLecturesThisMonth > 0) {
          actionBtn = OutlinedButton.icon(
              icon: const Icon(Icons.print, size: 16),
              label: const Text("Print"),
              onPressed: () {
                List<List<String>> receiptDetails = [];
                for (var doc in paidDocsThisMonth) {
                  final d = doc.data() as Map<String, dynamic>;
                  DateTime dt = (d['date'] as Timestamp).toDate();
                  int lecs = d['lectures'] as int;
                  double rowTotal = lecs * rate;
                  receiptDetails.add([
                    DateFormat('dd MMM yyyy').format(dt),
                    d['subject'] ?? '-',
                    lecs.toString(),
                    "₹ ${rate.toStringAsFixed(2)}",
                    "₹ ${rowTotal.toStringAsFixed(2)}"
                  ]);
                }

                ReceiptService.printReceipt(
                  facultyName: name,
                  department: dept,
                  month: DateFormat('MMMM yyyy').format(DateTime.now()),
                  totalLectures: displayLectures,
                  ratePerLecture: rate,
                  totalAmount: displayAmount,
                  paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  receiptId: "REC-${DateTime.now().millisecondsSinceEpoch}",
                  lectureDetails: receiptDetails,
                );
              }
          );
        } else {
          actionBtn = const SizedBox.shrink();
        }

        if (isDesktop) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Expanded(flex: 3, child: profileCol),
                Expanded(flex: 2, child: Text("$displayLectures Lectures", style: const TextStyle(fontWeight: FontWeight.w500))),
                Expanded(flex: 2, child: Text("₹${displayAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Expanded(flex: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: isOwed ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(isOwed ? "Pending" : "Paid Up", textAlign: TextAlign.center, style: TextStyle(color: isOwed ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)))),
                Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: actionBtn)),
              ],
            ),
          );
        } else {
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

  // ✅ BULLETPROOF PAYMENT LOGIC WITH STRICT WEB BOUNDARIES
  Future<void> _payFaculty(BuildContext context, String uid, List<QueryDocumentSnapshot> docs, String facultyName, double amount, String upiId) async {
    // 1. Grab theme safely before async gap
    final Color cardColor = Theme.of(context).cardColor;

    // 2. Format UPI String
    final String upiString = upiId.isNotEmpty
        ? "upi://pay?pa=$upiId&pn=${Uri.encodeComponent(facultyName)}&am=${amount.toStringAsFixed(2)}&cu=INR"
        : "";

    bool confirm = await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Pay $facultyName"),
          // ✅ 3. THE FIX: Strict Width to prevent Infinite Layout Loops on Web
          content: SizedBox(
            width: 320,
            // ✅ 4. THE FIX: Strict Height parameters
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Amount Due: ₹${amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Total Lectures: ${docs.length}", style: const TextStyle(color: Colors.grey)),

                if (upiId.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text("Scan to Pay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text("Use GPay, PhonePe, or Paytm on your phone", style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center,),
                  const SizedBox(height: 16),

                  // ✅ 5. THE FIX: Strict Box constraints for the QR code
                  Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: QrImageView(
                      data: upiString,
                      version: QrVersions.auto,
                      size: 180.0,
                      backgroundColor: Colors.white, // Forces visible paint on web
                    ),
                  ),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey))
            ),

            if (upiId.isNotEmpty)
              ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final Uri upiUrl = Uri.parse(upiString);
                      if (await canLaunchUrl(upiUrl)) {
                        await launchUrl(upiUrl, mode: LaunchMode.externalApplication);
                        if (context.mounted) Navigator.pop(c, true);
                      } else {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No UPI App found on this device.")));
                      }
                    } catch (e) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open UPI.")));
                    }
                  },
                  icon: const Icon(Icons.touch_app, size: 18),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  label: const Text("Open UPI App")
              ),

            ElevatedButton(
                onPressed: () => Navigator.pop(c, true),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff45a182)),
                child: const Text("Mark as Paid")
            ),
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