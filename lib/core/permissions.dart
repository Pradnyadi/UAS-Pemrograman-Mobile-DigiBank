import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  // Fungsi untuk mengecek dan meminta izin kamera
  static Future<bool> checkCameraPermission() async {
    // Cek status saat ini
    var status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    // Jika belum diizinkan, minta izin
    if (status.isDenied || status.isLimited) {
      status = await Permission.camera.request();
      return status.isGranted;
    }

    // Jika user memblokir permanen, arahkan ke settings (opsional)
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return false;
  }
}