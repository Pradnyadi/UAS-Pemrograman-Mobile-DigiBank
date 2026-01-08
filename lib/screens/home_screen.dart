import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, this.userName = "Dewa Made Pradnyadi Putra"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // 1. Header Biru Gelap
          Container(
            height: 260,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              image: DecorationImage(
                image: AssetImage('assets/bg_pattern.png'), // Opsional: jika ada pattern
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),

          // 2. Konten Utama (Scrollable)
          SafeArea(
            child: Column(
              children: [
                // Header Content (Logo & Nama)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris Atas: Logo & Menu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Icon Logo Sederhana
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text("DI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "DigiBank",
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Icon(Icons.more_vert, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Salam & Nama User
                      const Text(
                        "HALO,", 
                        style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Layer Body Putih Melengkung & Kartu Saldo
                Expanded(
                  child: Stack(
                    children: [
                      // Background Putih Melengkung
                      Container(
                        margin: const EdgeInsets.only(top: 50), // Turun sedikit agar kartu menumpuk
                        decoration: const BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),

                      // Isi Konten Body
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 0, bottom: 100),
                        child: Column(
                          children: [
                            // KARTU SALDO (Floating)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Saldo", style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Rp 500.000",
                                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                      Icon(Icons.visibility_off_outlined, color: Colors.black.withOpacity(0.6)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            // MENU UTAMA (Transfer, Tagihan, dll)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildMenuAction(Icons.swap_horizontal_circle_outlined, "Transfer"),
                                  _buildMenuAction(Icons.account_balance_wallet_outlined, "Tagihan"),
                                  _buildMenuAction(Icons.archive_outlined, "Tarik Tunai"), // Ikon mirip 'Tarik Tunai'
                                  _buildMenuAction(Icons.more_horiz_outlined, "Lainnya"),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // HISTORI TRANSAKSI
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Histori Transaksi", 
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                  GestureDetector(
                                    onTap: (){},
                                    child: const Text("Lihat Semua ->", 
                                      style: TextStyle(fontSize: 12, color: AppColors.lightBlue, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 10),

                            // List Items Histori
                            _buildHistoryItem("Transfer", "Yesterday • 19:12", "-Rp 600.000", AppColors.redNegative, Icons.swap_horiz),
                            _buildHistoryItem("Top Up", "May 29, 2025 • 19:12", "+Rp 260.000", AppColors.greenPositive, Icons.add_card),
                            _buildHistoryItem("Internet", "May 16, 2025 • 17:34", "-Rp 350.000", AppColors.redNegative, Icons.wifi),
                            _buildHistoryItem("Insurance", "April 23, 2025 • 11:28", "-Rp 2.000.000", AppColors.redNegative, Icons.health_and_safety),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 4. Custom Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.swap_horiz, "Home", true), // Icon Home diganti Swap sesuai gambar
            _buildNavItem(Icons.assignment_outlined, "Riwayat", false),
            
            // TOMBOL SCAN (Tengah Besar)
            GestureDetector(
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const QrisScannerScreen()));
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryBlue.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
                  ]
                ),
                child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
              ),
            ),

            _buildNavItem(Icons.history, "Histori", false),
            _buildNavItem(Icons.account_circle_outlined, "Profile", false),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Menu Atas (Transfer, Tagihan, dll)
  Widget _buildMenuAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Widget Helper untuk List Transaksi
  Widget _buildHistoryItem(String title, String date, String amount, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)] // Shadow halus opsional
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE3F2FD),
            child: Icon(icon, color: AppColors.primaryBlue, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // Widget Helper untuk Bottom Nav Item
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppColors.primaryBlue : Colors.grey, size: 26),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? AppColors.primaryBlue : Colors.grey, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}