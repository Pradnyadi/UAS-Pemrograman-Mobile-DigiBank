import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import GPS
import '../core/constants.dart';
import 'success_screen.dart';

class ResultScreen extends StatefulWidget {
  final String merchantName;
  final String? scannedAmount;

  const ResultScreen({
    super.key, 
    required this.merchantName, 
    this.scannedAmount
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController _amountController = TextEditingController();
  
  // Variabel untuk menyimpan lokasi pengguna
  Position? _currentPosition;
  String _locationMessage = "Mencari lokasi kamu...";
  bool _isLocationFound = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Langsung cari lokasi saat halaman dibuka
  }

  // --- FUNGSI CARI LOKASI (GPS) ---
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah GPS HP nyala
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationMessage = "GPS dimatikan user.");
      return;
    }

    // 2. Cek Izin Aplikasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationMessage = "Izin lokasi ditolak.");
        return;
      }
    }

    // 3. Ambil Koordinat (High Accuracy)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      _currentPosition = position;
      _isLocationFound = true;
      _locationMessage = "Lokasi Terdeteksi:\nLat: ${position.latitude}, Long: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFixedAmount = widget.scannedAmount != null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Konfirmasi Pembayaran", 
          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 1. KARTU INFO MERCHANT
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
                ]
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.accentLightBlue,
                    child: Icon(Icons.storefront, size: 30, color: AppColors.primaryBlue),
                  ),
                  const SizedBox(height: 10),
                  const Text("Pembayaran ke", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(widget.merchantName, 
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),
                  
                  // TAMPILAN NOMINAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Tagihan", style: TextStyle(fontWeight: FontWeight.w500)),
                      if (isFixedAmount)
                        Text(
                          "Rp ${widget.scannedAmount}", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                        )
                    ],
                  ),

                  // INPUT NOMINAL (Jika QR Statis)
                  if (!isFixedAmount)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                        decoration: const InputDecoration(
                          prefixText: "Rp ",
                          hintText: "0",
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryBlue)),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 2. KARTU LOKASI (SESUAI GAMBAR)
            // Menampilkan lokasi user saat ini (Geolocation Real-time)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    _isLocationFound ? Icons.location_on : Icons.location_searching, 
                    size: 40, 
                    color: _isLocationFound ? AppColors.greenPositive : Colors.grey.shade400
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isLocationFound ? "Lokasi Transaksi Terkunci" : "Mencari Lokasi Anda...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: _isLocationFound ? AppColors.textDark : Colors.grey
                    )
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _isLocationFound 
                      ? "${_currentPosition!.latitude}, ${_currentPosition!.longitude}"
                      : "Pastikan GPS aktif untuk memverifikasi lokasi",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 3. TOMBOL BAYAR
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  String finalAmount = isFixedAmount 
                      ? widget.scannedAmount! 
                      : _amountController.text;

                  if (finalAmount.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Masukkan nominal!")));
                    return;
                  }

                  // Kirim Data Lokasi ke Struk
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessScreen(
                        merchantName: widget.merchantName,
                        transactionDate: "26 Juni 2025 18:05:09", 
                        amount: finalAmount,
                        // Kirim koordinat asli (atau null jika gagal dapat gps)
                        latitude: _currentPosition?.latitude ?? -6.2088,
                        longitude: _currentPosition?.longitude ?? 106.8456,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  shadowColor: AppColors.primaryBlue.withOpacity(0.3),
                ),
                child: const Text("BAYAR SEKARANG", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}