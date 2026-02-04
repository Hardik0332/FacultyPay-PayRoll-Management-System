import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school,
                size: 48,
                color: Color(0xff45a182),
              ),
              const SizedBox(height: 12),
              const Text(
                "Faculty Salary System",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 12),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff45a182),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      if (!mounted) return; // ✅ FIX

                      await redirectBasedOnRole(context);

                    } catch (e) {
                      if (!mounted) return; // ✅ FIX

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },



                  child: const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> redirectBasedOnRole(BuildContext context) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

  if (!userDoc.exists) {
    throw Exception("User data not found in Firestore");
  }

  final role = userDoc['role'];

  if (role == 'admin') {
    Navigator.pushReplacementNamed(context, '/admin/dashboard');
  } else if (role == 'faculty') {
    Navigator.pushReplacementNamed(context, '/faculty/dashboard');
  } else {
    throw Exception("Invalid user role");
  }
}

