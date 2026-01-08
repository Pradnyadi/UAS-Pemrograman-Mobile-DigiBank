import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pastikan library ini ada
import '../core/constants.dart';
import 'home_screen.dart';

class SuccessScreen extends StatelessWidget {
  final String merchantName;
  final String transactionDate;
  final String amount;
  
  // 1. VARIABEL BARU: Untuk menyimpan Koordinat GPS
  final double latitude;
  final double longitude;

  const SuccessScreen({
    super.key,
    required this.merchantName,
    required this.transactionDate,
    required this.amount,
    // 2. Beri nilai default (Jakarta) jika GPS gagal, agar aplikasi tidak error
    this.latitude = -6.2088, 
    this.longitude = 106.8456,
  });

  // 3. FUNGSI BUKA MAPS (Updated)
  // Menggunakan koordinat asli dari parameter
  Future<void> _openMap() async {
    // Link format universal Google Maps
    final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    try {
      if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch maps');
      }
    } catch (e) {
      print("Error opening maps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Pattern
          Positioned(
            top: -50, right: -50,
            child: Icon(Icons.circle_outlined, size: 300, color: Colors.grey.withOpacity(0.05)),
          ),
          Positioned(
            top: 100, left: -100,
            child: Icon(Icons.circle_outlined, size: 400, color: Colors.grey.withOpacity(0.05)),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text("DigiBank", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                
                const SizedBox(height: 40),
                
                // Icon Centang Sukses
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF26A69A), width: 4),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xFF26A69A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                ),

                const SizedBox(height: 20),
                const Text("Pembayaran Berhasil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                const SizedBox(height: 8),
                Text(transactionDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),

                const SizedBox(height: 30),
                Text("Rp $amount", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),

                const SizedBox(height: 40),

                // Detail Transaksi
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("Jenis Transaksi", "QRIS"),
                      const Divider(height: 30),
                      _buildDetailRow("Sumber Dana", "800 - 2** - **24"),
                      const Divider(height: 30),
                      _buildDetailRow("Nama", merchantName),
                      const Divider(height: 30),
                      
                      // LINK LOKASI (GOOGLE MAPS)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Lokasi Toko", style: TextStyle(color: Colors.grey, fontSize: 14)),
                          InkWell(
                            onTap: _openMap, // Panggil fungsi buka peta
                            child: Row(
                              children: [
                                const Icon(Icons.map, size: 16, color: AppColors.primaryBlue),
                                const SizedBox(width: 5),
                                Text(
                                  "Lihat di Peta",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 14, 
                                    color: AppColors.primaryBlue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryBlue.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Tombol Selesai
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen(userName: "User DigiBank")),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Selesai", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  // Helper Widget untuk baris detail agar rapi
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value, 
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 14, 
              color: AppColors.textDark
            ),
          ),
        ),
      ],
    );
  }
}