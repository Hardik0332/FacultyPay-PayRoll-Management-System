import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditFacultyPage extends StatefulWidget {
  final String facultyId;
  final Map<String, dynamic> facultyData;

  const EditFacultyPage({
    super.key,
    required this.facultyId,
    required this.facultyData,
  });

  @override
  State<EditFacultyPage> createState() => _EditFacultyPageState();
}

class _EditFacultyPageState extends State<EditFacultyPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController rateController;
  String? selectedDepartment;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.facultyData['name']);
    emailController =
        TextEditingController(text: widget.facultyData['email']);
    rateController = TextEditingController(
        text: widget.facultyData['hourlyRate'].toString());
    selectedDepartment = widget.facultyData['department'];
  }

  Future<void> updateFaculty() async {
    await FirebaseFirestore.instance
        .collection('faculty')
        .doc(widget.facultyId)
        .update({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'hourlyRate': double.parse(rateController.text),
      'department': selectedDepartment,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Faculty updated successfully")),
    );

    Navigator.pop(context); // go back to View Faculty
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Faculty")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Hourly Rate"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              items: const [
                DropdownMenuItem(value: "cs", child: Text("Computer Science")),
                DropdownMenuItem(value: "eng", child: Text("Engineering")),
                DropdownMenuItem(value: "arts", child: Text("Arts")),
                DropdownMenuItem(value: "bus", child: Text("Business")),
              ],
              onChanged: (value) {
                setState(() => selectedDepartment = value);
              },
              decoration:
              const InputDecoration(labelText: "Department"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: updateFaculty,
              child: const Text("Update Faculty"),
            ),
          ],
        ),
      ),
    );
  }
}
