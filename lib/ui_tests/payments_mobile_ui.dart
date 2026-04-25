import 'dart:ui';
import 'package:flutter/material.dart';

class PaymentsMobileUI extends StatefulWidget {
  const PaymentsMobileUI({super.key});

  @override
  State<PaymentsMobileUI> createState() => _PaymentsMobileUIState();
}

class _PaymentsMobileUIState extends State<PaymentsMobileUI> {
  final Color primaryRed = const Color(0xFFE05B5C);

  int _currentNavIndex = 0; // Set default home to 0 to match screenshot
  int _currentTabIndex = 0;

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
            initialChildSize: 0.62, // Starts exactly in the middle
            minChildSize: 0.62,     // Will snap back to the middle
            maxChildSize: 0.88,     // Will snap to the top
            snap: true,             // MAGICAL FIX: Snaps into position when released!
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
                    // --- DRAG HANDLE AREA (Only this controls the sheet!) ---
                    SingleChildScrollView(
                      controller: scrollController, // We ONLY give the controller to the handle
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 16, bottom: 20),
                        color: Colors.transparent, // Makes the whole top strip grab-able
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

                    // --- THE LIST (Scrolls normally, does not drag the sheet) ---
                    Expanded(
                      child: ListView(
                        // NO scroll controller here!
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                        physics: const BouncingScrollPhysics(), // Gives it that smooth native bounce
                        children: [
                          _buildSegmentedTabs(),
                          const SizedBox(height: 24),
                          _buildTransactionList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 4. Floating Bottom Navigation (Stays on top of everything)
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

  // --- HEADER UPDATED WITH PRINT ICON ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("FacultyPay", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
        Row(
          children: [
            // NEW: Print Icon
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Icons.print, color: Colors.white, size: 20)),
            const SizedBox(width: 12),
            // Existing: Notification Icon
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryRed, shape: BoxShape.circle), child: const Icon(Icons.notifications, color: Colors.white, size: 20)),
            const SizedBox(width: 12),
            // Existing: Profile Icon
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Icons.person, color: Colors.white, size: 20)),
          ],
        )
      ],
    );
  }

  // --- MASTER CARD UPDATED WITH NEW TEXT ---
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
                    const Text("Payments", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text("Overview of recent faculty distributions.", style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),

                    const SizedBox(height: 24),

                    // UPDATED: "TOTAL EARNED"
                    Text("TOTAL EARNED", style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text("\$124,500.00", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: primaryRed)),

                    const SizedBox(height: 24),

                    // UPDATED: "PENDING PAYMENT"
                    Text("PENDING PAYMENT", style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    const Text("\$450.00", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildSegmentedTabs() {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          _buildTab("All Payments", 0),
          const SizedBox(width: 8),
          _buildTab("Completed", 1),
          const SizedBox(width: 8),
          _buildTab("Pending", 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isActive = _currentTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? primaryRed : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isActive ? primaryRed : Colors.white.withValues(alpha: 0.2)),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.8), fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, fontSize: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Stack(
      children: [
        Positioned(left: 35, top: 30, bottom: 30, child: Container(width: 1.5, color: primaryRed.withValues(alpha: 0.4))),
        Column(
          children: [
            _buildTransactionItem(Icons.price_change, "September Salary", "\$5,420.00", "COMPLETED", true, isRedIcon: true),
            _buildTransactionItem(Icons.menu_book, "Research Grant Q3", "\$2,100.00", "COMPLETED", true, isRedIcon: false),
            _buildTransactionItem(Icons.flight_takeoff, "Travel Reimbursement", "\$450.00", "PROCESSING", false, isRedIcon: false),
            _buildTransactionItem(Icons.account_balance_wallet, "August Salary", "\$5,420.00", "COMPLETED", true, isRedIcon: true),
            // Added one more so you can test scrolling up!
            _buildTransactionItem(Icons.price_change, "July Salary", "\$5,420.00", "COMPLETED", true, isRedIcon: true),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionItem(IconData icon, String title, String amount, String status, bool isCompleted, {required bool isRedIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF2A2E39), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
        child: Row(
          children: [
            Container(width: 42, height: 42, decoration: BoxDecoration(color: isRedIcon ? primaryRed : const Color(0xFF4A5060), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 20)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(amount, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: (isCompleted ? primaryRed : const Color(0xFFD97A7A)).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: (isCompleted ? primaryRed : const Color(0xFFD97A7A)).withValues(alpha: 0.3))),
              child: Text(status, style: TextStyle(color: isCompleted ? primaryRed : const Color(0xFFD97A7A), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
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