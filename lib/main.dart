import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/admin/admin_dashboard.dart';
import 'pages/admin/add_faculty.dart';
import 'pages/admin/view_faculty_page.dart';
import 'pages/admin/admin_view_attendance_page.dart'; // Import this
import 'pages/admin/calculate_salary_screen.dart'; // Import this
import 'pages/faculty/faculty_dashboard.dart';
import 'pages/faculty/add_attendance_page.dart';
import 'services/auth_gate.dart';
import 'pages/faculty/faculty_salary_summary_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College SMS',
      theme: ThemeData(
        primaryColor: const Color(0xff45a182),
        useMaterial3: false,
      ),
      home: const AuthGate(),
      // ✅ ALL ROUTES REGISTERED HERE
      routes: {
        '/admin/dashboard': (context) => const AdminDashboard(),
        '/admin/add-faculty': (context) => const AddFacultyPage(),
        '/admin/view-faculty': (context) => const ViewFacultyPage(),
        '/admin/view-attendance': (context) => const AdminViewAttendancePage(),
        '/admin/calculate-salary': (context) => const CalculateSalaryScreen(),
        '/faculty/salary-history': (context) => const FacultySalaryHistoryPage(),
        '/faculty/dashboard': (context) => const FacultyDashboard(),
        '/faculty/add-attendance': (context) => const FacultyAddAttendancePage(),
      },
    );
  }
}