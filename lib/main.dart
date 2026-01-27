import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/admin/admin_dashboard.dart';
import 'pages/admin/add_faculty.dart';
import 'pages/faculty/faculty_dashboard.dart';
import 'pages/admin/admin_view_attendance_page.dart';
import 'pages/admin/calculate_salary_screen.dart';
import 'pages/faculty/add_attendance_page.dart';
import 'pages/faculty/faculty_salary_summary_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/faculty/salary-summary',

      routes: {
        '/': (context) => LoginPage(),
        '/admin/dashboard': (context) => AdminDashboard(),
        '/admin/add-faculty': (context) => AddFacultyPage(),
        '/admin/view-attendance': (context) => AdminViewAttendancePage(),
        '/admin/calculate-salary': (context) => CalculateSalaryScreen(),
        '/faculty/dashboard': (context) => FacultyDashboard(),
        '/faculty/add-attendance': (context) => FacultyAddAttendancePage(),
        '/faculty/salary-summary': (context) => FacultySalarySummaryPage(),
      }
      ,
    );
  }
}
