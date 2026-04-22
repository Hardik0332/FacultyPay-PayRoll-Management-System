import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final bool remembered = prefs.getBool('remember_me') ?? false;
    if (remembered) {
      setState(() {
        rememberMe = true;
        emailController.text = prefs.getString('remembered_email') ?? '';
        passwordController.text = prefs.getString('remembered_password') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The deep charcoal-to-midnight-blue linear gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff0f172a), Color(0xff1e293b)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // The Frosted Effect
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: const Color(0xff1e293b).withValues(alpha: 0.6), // Glass Card Background
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)), // Rim Lighting
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, blurRadius: 32, offset: Offset(0, 8))
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xff45a182).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.school, size: 40, color: Color(0xff45a182)),
                      ),
                      const SizedBox(height: 24),
                      const Text("FacultyPay", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 8),
                      const Text(
                        "Secure access to your academic\nfinancial dashboard.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xff94a3b8), fontSize: 14),
                      ),
                      const SizedBox(height: 40),

                      // EMAIL FIELD
                      _buildLabel("Institution Email"),
                      TextField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: _glassInputDecoration("faculty@university.edu"),
                      ),
                      const SizedBox(height: 20),

                      // PASSWORD FIELD
                      _buildLabel("Password"),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (!isLoading) _handleEmailLogin();
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: _glassInputDecoration("••••••••"),
                      ),
                      const SizedBox(height: 16),

                      // REMEMBER ME & FORGOT PASSWORD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: rememberMe,
                                  onChanged: (val) => setState(() => rememberMe = val ?? false),
                                  fillColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? const Color(0xff45a182) : Colors.transparent),
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text("Remember me", style: TextStyle(color: Color(0xff94a3b8), fontSize: 13)),
                            ],
                          ),
                          TextButton(
                            onPressed: _showForgotPasswordDialog,
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text("Forgot password?", style: TextStyle(color: Color(0xff94a3b8), fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // SIGN IN BUTTON (Crimson Accent)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffe11d48), // Crimson Accent
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            shadowColor: const Color(0xffe11d48).withValues(alpha: 0.5),
                            elevation: 8,
                          ),
                          onPressed: isLoading ? null : _handleEmailLogin,
                          child: isLoading
                              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                              : const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // DIVIDER
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("OR SIGN IN WITH", style: TextStyle(color: Color(0xff94a3b8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // SSO BUTTONS
                      _buildSSOButton("Google", "assets/images/google.png", _signInWithGoogle),
                      const SizedBox(height: 16),
                      _buildSSOButton("Microsoft", "assets/images/microsoft.png", _signInWithMicrosoft),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI HELPERS ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(color: Color(0xff94a3b8), fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }

  InputDecoration _glassInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff45a182)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  Widget _buildSSOButton(String provider, String iconPath, VoidCallback action) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isLoading ? null : action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 20, width: 20, errorBuilder: (_, __, ___) => const Icon(Icons.language, color: Colors.white)),
            const SizedBox(width: 12),
            Text(provider, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // --- AUTHENTICATION LOGIC (Kept EXACTLY from your original file) ---
  Future<void> _handleEmailLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter both email and password");
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('remembered_email', email);
        await prefs.setString('remembered_password', password);
      } else {
        await prefs.setBool('remember_me', false);
        await prefs.remove('remembered_email');
        await prefs.remove('remembered_password');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => isLoading = false);
      _showError(e.code);
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      _showError(e.toString());
    }
  }

  void _showForgotPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController(text: emailController.text.trim());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1e293b),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Reset Password", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your email address to receive a reset link.", style: TextStyle(color: Color(0xff94a3b8))),
              const SizedBox(height: 20),
              TextField(
                controller: resetEmailController,
                style: const TextStyle(color: Colors.white),
                decoration: _glassInputDecoration("Email"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Color(0xff94a3b8)))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff45a182)),
              onPressed: () async {
                final email = resetEmailController.text.trim();
                if (email.isEmpty) return;
                Navigator.pop(context);
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  _showSnackBar("Reset link sent! Please check your email.", isSuccess: true);
                } on FirebaseAuthException catch (e) {
                  _showSnackBar(_getFriendlyErrorMessage(e.code), isSuccess: false);
                }
              },
              child: const Text("Send Link", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        await GoogleSignIn.instance.initialize(
          serverClientId: '1085093252774-4ee6ucv8alpslq5jvklba1pokdi2m68c.apps.googleusercontent.com',
        );
        final GoogleSignInAccount? gUser = await GoogleSignIn.instance.authenticate();
        if (gUser == null) {
          if (mounted) setState(() => isLoading = false);
          _showError("popup-closed-by-user");
          return;
        }
        final GoogleSignInAuthentication gAuth = gUser.authentication;
        final credential = GoogleAuthProvider.credential(idToken: gAuth.idToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      if (e is FirebaseAuthException) {
        _showError(e.code);
      } else {
        _showError("popup-closed-by-user");
      }
    }
  }

  Future<void> _signInWithMicrosoft() async {
    setState(() => isLoading = true);
    try {
      final provider = OAuthProvider('microsoft.com');
      provider.setCustomParameters({'prompt': 'select_account'});
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(provider);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      if (e is FirebaseAuthException) {
        _showError(e.code);
      } else {
        _showError("popup-closed-by-user");
      }
    }
  }

  void _showError(String code) {
    if (!mounted) return;
    setState(() => isLoading = false);
    _showSnackBar(_getFriendlyErrorMessage(code), isSuccess: false);
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: isSuccess ? Colors.green : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getFriendlyErrorMessage(String code) {
    if (code.contains('user-not-found')) return "No account found for that email address.";
    if (code.contains('wrong-password')) return "Incorrect password. Please try again.";
    if (code.contains('invalid-email')) return "Please enter a valid email address.";
    if (code.contains('popup-closed-by-user') || code.contains('cancelled')) return "Sign-in was cancelled.";
    if (code.contains('too-many-requests')) return "Too many failed attempts. Please try resetting your password.";
    return "Authentication Failed: $code";
  }
}