import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../widgets/app_sidebars.dart'; // ✅ This import will work now!

class AddFacultyPage extends StatefulWidget {
  const AddFacultyPage({super.key});

  @override
  State<AddFacultyPage> createState() => _AddFacultyPageState();
}

class _AddFacultyPageState extends State<AddFacultyPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  String? selectedDepartment;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // ✅ USE SHARED SIDEBAR
          const AdminSidebar(activeRoute: '/admin/add-faculty'),

          // MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add Faculty Member", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  // FORM CONTAINER
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Full Name"),
                        TextField(controller: nameController, decoration: _inputDeco("e.g. Dr. Sarah Connor")),
                        const SizedBox(height: 24),

                        _buildLabel("Email Address"),
                        TextField(controller: emailController, decoration: _inputDeco("faculty@university.edu", icon: Icons.email_outlined)),
                        const SizedBox(height: 24),

                        _buildLabel("Set Password"),
                        TextField(controller: passwordController, obscureText: true, decoration: _inputDeco("Login password", icon: Icons.lock_outline)),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("Hourly Rate"),
                                  TextField(
                                    controller: rateController,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDeco("0.00", prefix: "\$ ", suffix: "USD/hr"),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("Department"),
                                  DropdownButtonFormField<String>(
                                    value: selectedDepartment,
                                    items: const [
                                      DropdownMenuItem(value: "cs", child: Text("Computer Science")),
                                      DropdownMenuItem(value: "eng", child: Text("Engineering")),
                                      DropdownMenuItem(value: "arts", child: Text("Liberal Arts")),
                                    ],
                                    onChanged: (v) => setState(() => selectedDepartment = v),
                                    decoration: _inputDeco("Select Dept"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                        const Divider(),
                        const SizedBox(height: 20),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: isLoading ? null : _saveFaculty,
                              icon: isLoading ? const SizedBox() : const Icon(Icons.save),
                              label: Text(isLoading ? "Saving..." : "Save Faculty"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff45a182),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              ),
                            ),
                          ],
                        )
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

  // Helper for Styling
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  InputDecoration _inputDeco(String hint, {IconData? icon, String? prefix, String? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      prefixText: prefix,
      suffixText: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Future<void> _saveFaculty() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || rateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isLoading = true);

    try {
      FirebaseApp tempApp = await Firebase.initializeApp(name: 'tempRegApp', options: Firebase.app().options);

      UserCredential cred = await FirebaseAuth.instanceFor(app: tempApp).createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'role': 'faculty',
        'department': selectedDepartment,
        'hourlyRate': double.parse(rateController.text),
        'createdAt': Timestamp.now(),
      });

      await tempApp.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Faculty Added Successfully")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}