import 'dart:io';
import '../constants/whatsapp_path.dart';
import 'package:flutter/foundation.dart';

class WhatsAppService {
  static Future<void> createAppFolders() async {
    final whatsappDir = Directory(WhatsAppPath.whatsappDir);
    final whatsappBDir = Directory(WhatsAppPath.whatsappBDir);

    if (!await whatsappDir.exists()) {
      await whatsappDir.create(recursive: true);
      debugPrint("Created folder: ${whatsappDir.path}");
    }

    if (!await whatsappBDir.exists()) {
      await whatsappBDir.create(recursive: true);
      debugPrint("Created folder: ${whatsappBDir.path}");
    }
  }
}
