import 'package:flutter/material.dart';
import '../core/constants.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key});

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animasi laser naik-turun (durasi 2 detik)
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran kotak scan: 70% dari lebar layar
    double scanAreaSize = MediaQuery.of(context).size.width * 0.7;

    return Stack(
      children: [
        // 1. Layer Gelap dengan Lubang Transparan (Hole)
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            AppColors.overlayDark,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: scanAreaSize,
                  width: scanAreaSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25), // Sudut lebih halus
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. Layer Frame (Garis Tepi Kotak)
        Center(
          child: Container(
            height: scanAreaSize,
            width: scanAreaSize,
            decoration: BoxDecoration(
              // Menggunakan warna Biru DigiBank
              border: Border.all(color: AppColors.primaryBlue, width: 2.5),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),

        // 3. Layer Animasi Garis Laser (Scanner Line)
        Center(
          child: SizedBox(
            height: scanAreaSize,
            width: scanAreaSize,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: _animation.value * scanAreaSize,
                      left: 15,
                      right: 15,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryBlue.withOpacity(0.01),
                              AppColors.primaryBlue,
                              AppColors.primaryBlue.withOpacity(0.01),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}