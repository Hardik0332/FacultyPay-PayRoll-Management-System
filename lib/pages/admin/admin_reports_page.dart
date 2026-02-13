import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_sidebars.dart';
import '../../services/report_service.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  String? selectedFacultyId; // Null means "All Faculty"
  Map<String, String> facultyNames = {}; // Stores UID -> Name mapping
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFacultyNames();
  }

  // Pre-fetch all faculty names so we can show them in the PDF
  Future<void> _fetchFacultyNames() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'faculty').get();
    final Map<String, String> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = doc['name'] ?? 'Unknown';
    }
    setState(() => facultyNames = tempMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          const AdminSidebar(activeRoute: '/admin/reports'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Attendance Reports", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),

                  // FILTER CARD
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Generate PDF Report", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            // DROPDOWN
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: "Select Faculty",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                value: selectedFacultyId,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text("All Faculty (Master Report)")),
                                  ...facultyNames.entries.map((e) => DropdownMenuItem(
                                    value: e.key,
                                    child: Text(e.value),
                                  )),
                                ],
                                onChanged: (val) => setState(() => selectedFacultyId = val),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // PRINT BUTTON
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff45a182),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                              ),
                              icon: isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                                  : const Icon(Icons.print),
                              label: const Text("Generate PDF"),
                              onPressed: isLoading ? null : _generateReport,
                            ),
                          ],
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

  Future<void> _generateReport() async {
    setState(() => isLoading = true);

    try {
      Query query = FirebaseFirestore.instance.collection('attendance').orderBy('date', descending: true);

      String reportTitle = "Master Attendance Report";
      String subTitle = "All Faculty Records";

      // Apply Filter if specific faculty selected
      if (selectedFacultyId != null) {
        query = query.where('uid', isEqualTo: selectedFacultyId);
        reportTitle = "Individual Attendance Report";
        subTitle = "Faculty: ${facultyNames[selectedFacultyId] ?? 'Unknown'}";
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No records found for this selection")));
      } else {
        await ReportService.printHistoryReport(
          title: reportTitle,
          subtitle: subTitle,
          docs: snapshot.docs,
          isAdminReport: true, // Shows "Faculty Name" column
          facultyNames: facultyNames,
        );
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if(mounted) setState(() => isLoading = false);
    }
  }
}