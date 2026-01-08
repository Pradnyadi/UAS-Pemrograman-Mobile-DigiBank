import 'package:flutter/material.dart';

class AppColors {
  // Warna Utama (DigiBank)
  static const Color primaryBlue = Color(0xFF003D70); 
  static const Color lightBlue = Color(0xFF00569E);
  
  // Warna Tambahan (YANG TADI HILANG & Bikin Error)
  static const Color accentLightBlue = Color(0xFFE3F2FD); 
  
  // Background
  static const Color scaffoldBg = Color(0xFFF8F9FA);
  static const Color cardBg = Colors.white;

  // Warna Status Transaksi
  static const Color redNegative = Color(0xFFE53935);
  static const Color greenPositive = Color(0xFF43A047);
  
  // Warna Teks
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Colors.white;
  static const Color textGrey = Color(0xFF757575);

  // Overlay Laser Scanner
  static final Color overlayDark = Colors.black.withOpacity(0.7);
}

// Style Text (YANG TADI HILANG, bikin error di Scanner)
class AppStyles {
  static const TextStyle headerStyle = TextStyle(
    color: AppColors.textLight,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static const TextStyle instructionStyle = TextStyle(
    color: AppColors.textLight,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}