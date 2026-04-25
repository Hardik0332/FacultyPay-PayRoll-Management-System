import 'dart:ui';
import 'package:flutter/material.dart';

class FacultyDashboardUI extends StatefulWidget {
  const FacultyDashboardUI({super.key});

  @override
  State<FacultyDashboardUI> createState() => _FacultyDashboardUIState();
}

class _FacultyDashboardUIState extends State<FacultyDashboardUI> {
  final Color primaryRed = const Color(0xFFE05B5C);
  final Color successGreen = const Color(0xFF4ADE80); // For PAID
  final Color pendingOrange = const Color(0xFFFBBF24); // For PENDING
  final Color verifiedBlue = const Color(0xFF60A5FA); // For VERIFIED

  int _currentNavIndex = 0; // Starts on HOME

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282C37),
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF3B4154), Color(0xFF1E212A)],
              ),
            ),
          ),

          // 2. Fixed Background Content (Header & Master Card)
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: _buildHeader(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildMasterCard(),
                ),
              ],
            ),
          ),

          // 3. THE DRAGGABLE BOTTOM SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.62,
            minChildSize: 0.62,
            maxChildSize: 0.88,
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF242832),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, -5))
                  ],
                ),
                child: Column(
                  children: [
                    // --- DRAG HANDLE AREA ---
                    SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 16, bottom: 20),
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // --- THE SALARY LIST ---
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const Text(
                            "Recent Salary Records",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSalaryList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 4. Floating Bottom Navigation
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildFloatingBottomNav(),
          ),
        ],
      ),
    );
  }

  // --- HEADER UPDATED (Removed Print Icon) ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("FacultyPay", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
        Row(
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryRed, shape: BoxShape.circle), child: const Icon(Icons.notifications, color: Colors.white, size: 20)),
            const SizedBox(width: 12),
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Icons.person, color: Colors.white, size: 20)),
          ],
        )
      ],
    );
  }

  Widget _buildMasterCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.05)]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Morning,", style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                    const SizedBox(height: 2),
                    const Text("Dr. Sarah Smith", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),

                    const SizedBox(height: 24),

                    Text("TOTAL EARNINGS", style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text("\$124,500.00", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: primaryRed)),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TOTAL LECTURES", style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            const Text("142", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("HOURLY RATE", style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            const Text("\$150.00", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Image.asset('assets/images/bank.png', width: 100, height: 100, fit: BoxFit.contain),
            ],
          ),
        ),
      ),
    );
  }

  // --- REBUILT SALARY LIST ---
  Widget _buildSalaryList() {
    return Stack(
      children: [
        Positioned(left: 35, top: 30, bottom: 30, child: Container(width: 1.5, color: Colors.white.withValues(alpha: 0.1))),
        Column(
          children: [
            _buildSalaryItem(Icons.pending_actions, "October 2023 Salary", "Expected Oct 31", "PENDING", pendingOrange),
            _buildSalaryItem(Icons.verified, "September 2023 Salary", "Processed on Oct 01", "VERIFIED", verifiedBlue),
            _buildSalaryItem(Icons.description, "Q3 Bonus Distribution", "Processed on Sep 15", "PAID", successGreen),
            _buildSalaryItem(Icons.description, "August 2023 Salary", "Processed on Sep 01", "PAID", successGreen),
            _buildSalaryItem(Icons.description, "July 2023 Salary", "Processed on Aug 01", "PAID", successGreen),
          ],
        ),
      ],
    );
  }

  Widget _buildSalaryItem(IconData icon, String title, String details, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF2A2E39), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
        child: Row(
          children: [
            Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF4A5060), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 20)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(details, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withValues(alpha: 0.3))),
              child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: 0.15), Colors.white.withValues(alpha: 0.05)]),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, "HOME", 0),
              _buildNavItem(Icons.people, "STAFF", 1),
              _buildNavItem(Icons.account_balance_wallet, "PAY", 2),
              _buildNavItem(Icons.more_horiz, "MORE", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentNavIndex == index;
    final color = isActive ? primaryRed : Colors.white.withValues(alpha: 0.4);
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            if (isActive)
              Container(margin: const EdgeInsets.only(top: 4), height: 3, width: 20, decoration: BoxDecoration(color: primaryRed, borderRadius: BorderRadius.circular(2)))
          ],
        ),
      ),
    );
  }
}