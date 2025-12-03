import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class WhatsAppPath {
  static Future<String> getWhatsAppPath() async {
    // Check the version of Android
    if (Platform.isAndroid) {
      // Android 10 and above
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      String androidVersion = androidInfo.version.release;
      // debugPrint(androidVersion);
      if (int.parse(androidVersion) >= 10) {
        return "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
      } else {
        return "/storage/emulated/0/WhatsApp/Media/.Statuses";
      }
    } else {
      return "/storage/emulated/0/WhatsApp/Media/.Statuses";
    }
  }

  static Future<String> getWhatsAppBPath() async {
    // Check the version of Android
    if (Platform.isAndroid) {
      // Android 10 and above
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      String androidVersion = androidInfo.version.release;
      // debugPrint(androidVersion);
      if (int.parse(androidVersion) >= 10) {
        return "/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";
      } else {
        return "/storage/emulated/0/WhatsApp Business/Media/.Statuses";
      }
    } else {
      return "/storage/emulated/0/WhatsApp Business/Media/.Statuses";
    }
  }

  static const whatsappDir = "/storage/emulated/0/WhatsAppStatusSaver/WhatsApp";
  static const whatsappBDir = "/storage/emulated/0/WhatsAppStatusSaver/WhatsApp Business";
}
