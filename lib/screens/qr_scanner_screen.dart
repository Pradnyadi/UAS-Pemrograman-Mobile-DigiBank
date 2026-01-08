import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/constants.dart';
import '../widgets/scanner_overlay.dart'; // Pastikan file overlay ada
import '../widgets/ios_button.dart'; // Pastikan file button ada
import 'result_screen.dart';

class QrisScannerScreen extends StatefulWidget {
  const QrisScannerScreen({super.key});

  @override
  State<QrisScannerScreen> createState() => _QrisScannerScreenState();
}

class _QrisScannerScreenState extends State<QrisScannerScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool isFinished = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // --- LOGIC CERDAS: PARSING QRIS ---
  void _handleQrDetection(BarcodeCapture capture) {
    if (isFinished) return;

    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty) {
      final String? rawCode = barcodes.first.rawValue;
      
      if (rawCode != null) {
        setState(() => isFinished = true); // Stop scanning

        // 1. Ekstrak Data (Nama & Harga) menggunakan fungsi helper
        Map<String, String?> qrisData = _parseQrisData(rawCode);
        
        String merchantName = qrisData['name'] ?? "Unknown Merchant";
        String? amount = qrisData['amount'];

        // 2. Pindah ke Halaman Hasil
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              merchantName: merchantName,
              scannedAmount: amount,
            ),
          ),
        ).then((_) {
          // Reset saat kembali
          if (mounted) {
            setState(() => isFinished = false);
            controller.start();
          }
        });
      }
    }
  }

  // --- FUNGSI PENERJEMAH KODE QRIS (PARSER) ---
  Map<String, String?> _parseQrisData(String rawQr) {
    String name = rawQr;
    String? amount;

    // A. Cek Format Dummy Tugas (NamaToko|Harga)
    if (rawQr.contains('|')) {
      final parts = rawQr.split('|');
      name = parts[0];
      if (parts.length > 1) amount = parts[1];
      return {'name': name, 'amount': amount};
    }

    // B. Cek Format QRIS ASLI (Standar EMVCo, diawali '00')
    // Contoh string di gambar: 000201010211...5910Multi Zone...
    if (rawQr.startsWith('00')) {
      try {
        int index = 0;
        while (index < rawQr.length) {
          // Format QRIS: ID(2 digit) + Panjang(2 digit) + Value
          String id = rawQr.substring(index, index + 2);
          int length = int.parse(rawQr.substring(index + 2, index + 4));
          String value = rawQr.substring(index + 4, index + 4 + length);

          // ID "59" adalah ID untuk "Merchant Name"
          if (id == '59') {
            name = value; // KETEMU! Contoh: "Multi Zone"
          }
          // ID "54" adalah ID untuk "Transaction Amount" (Jarang ada di QR Statis)
          else if (id == '54') {
            amount = value;
          }

          // Lanjut ke tag berikutnya
          index += 4 + length;
        }
      } catch (e) {
        // Jika gagal parsing, gunakan nama default agar tidak error
        name = "QRIS Merchant";
      }
    } 
    
    // C. Jika bukan keduanya tapi string terlalu panjang (Raw Data Rusak)
    else if (rawQr.length > 25) {
      name = "QRIS Transaction"; // Nama fallback biar rapi
    }

    return {'name': name, 'amount': amount};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleQrDetection,
          ),
          
          // Overlay (Pastikan widget ini ada di project kamu)
          const ScannerOverlay(), 

          // Tombol Back
          Positioned(
            top: 50, left: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Kontrol Bawah
          Positioned(
            bottom: 60, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IosButton(
                  icon: Icons.flash_on,
                  label: "Senter",
                  onTap: () => controller.toggleTorch(),
                ),
                IosButton(
                  icon: Icons.image,
                  label: "Galeri",
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          const Positioned(
            top: 150, left: 0, right: 0,
            child: Center(
              child: Text(
                "Pindai kode QRIS untuk membayar",
                style: TextStyle(color: Colors.white, fontSize: 14, shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}