import 'package:flutter/material.dart';

class AddFacultyPage extends StatelessWidget {
  const AddFacultyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f7),
      body: Row(
        children: [
          // ================= SIDEBAR =================
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xffe6f4ea),
                        child: Icon(Icons.account_balance,
                            color: Color(0xff45a182), size: 18),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Salary Manager",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                _sideItem("Dashboard", Icons.dashboard),
                _sideItem("Add Faculty", Icons.person_add, active: true),
                _sideItem("View Faculty", Icons.groups),
                _sideItem("Settings", Icons.settings),

                const Spacer(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= MAIN CONTENT =================
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Add Faculty Member",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xff45a182),
                        child: Text(
                          "A",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Breadcrumb
                            Row(
                              children: const [
                                Text("Faculty",
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(width: 6),
                                Text("/"),
                                SizedBox(width: 6),
                                Text("Add New",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Create a new faculty profile to manage their courses, hours, and salary details. All fields are required unless marked otherwise.",
                              style: TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 24),

                            // ================= FORM CARD =================
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Full Name
                                  const Text("Full Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "e.g. Dr. Sarah Connor",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Email
                                  const Text("Email Address",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "faculty@university.edu",
                                      prefixIcon: const Icon(Icons.mail),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Rate & Department
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            const Text("Hourly Rate",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w600)),
                                            const SizedBox(height: 6),
                                            TextField(
                                              keyboardType:
                                              TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: "0.00",
                                                prefixText: "\$ ",
                                                suffixText: "USD / hr",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            const Text("Department",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w600)),
                                            const SizedBox(height: 6),
                                            DropdownButtonFormField<String>(
                                              items: const [
                                                DropdownMenuItem(
                                                    value: "cs",
                                                    child: Text(
                                                        "Computer Science")),
                                                DropdownMenuItem(
                                                    value: "eng",
                                                    child:
                                                    Text("Engineering")),
                                                DropdownMenuItem(
                                                    value: "arts",
                                                    child:
                                                    Text("Liberal Arts")),
                                                DropdownMenuItem(
                                                    value: "bus",
                                                    child: Text("Business")),
                                              ],
                                              onChanged: (value) {},
                                              decoration: InputDecoration(
                                                hintText: "Select Department",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),
                                  const Divider(),

                                  // Actions
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text("Cancel"),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.save, size: 18),
                                        label: const Text("Save Faculty"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xff45a182),
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= SIDEBAR ITEM =================
Widget _sideItem(String title, IconData icon, {bool active = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: active ? const Color(0xffe6f4ea) : null,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      leading: Icon(icon,
          size: 20,
          color: active ? const Color(0xff45a182) : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          color: active ? const Color(0xff45a182) : Colors.black,
        ),
      ),
      onTap: () {},
    ),
  );
}
