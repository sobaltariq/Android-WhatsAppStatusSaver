import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_status_saver/constants/whatsapp_path.dart';
import 'package:get/get.dart';

class StatusController extends GetxController {
  RxList imagesList = <FileSystemEntity>[].obs;
  RxList videosList = <FileSystemEntity>[].obs;
  RxList allList = <FileSystemEntity>[].obs;

  RxString whatsAppType = "WhatsApp".obs;

  // true for whatsapp false for business
  RxBool whatsAppPath = true.obs;

  RxBool permissionFound = false.obs;

  void setWhatsAppType(String value) {
    whatsAppType.value = value;
  }

  void setWhatsAppPath(bool value) {
    whatsAppPath.value = value;
  }

  Future<void> getStatus(String extensions) async {
    debugPrint("Get Status");
    PermissionStatus status;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      String androidVersion = androidInfo.version.release;
      debugPrint("Android Version $androidVersion");
      if (int.parse(androidVersion) >= 11) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        debugPrint("Permission Denied");
        permissionFound.value = false;
        await Permission.storage.request();
        return;
      }

      if (status.isGranted) {
        final directoryPath = whatsAppType.value == "WhatsAppB" ? await WhatsAppPath.getWhatsAppBPath() : await WhatsAppPath.getWhatsAppPath();
        final directory = Directory(directoryPath);
        if (directory.existsSync()) {
          final items = await directory.list().toList();

          if (extensions == ".jpg") {
            imagesList.value = items.where((element) => element.path.endsWith(".jpg")).toList();
            debugPrint("PIC $imagesList");
          }

          if (extensions == ".mp4") {
            videosList.value = items.where((element) => element.path.endsWith(".mp4")).toList();
            debugPrint("VID $videosList");
          }
        } else {
          debugPrint("WhatsApp Directory Not Found");
        }

        permissionFound.value = true;
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
        permissionFound.value = false;
        debugPrint("Permission Denied: $permissionFound");
      }
    }
  }

  // to get saved in my app folder
  Future<void> getSaved() async {
    debugPrint("Get Saved");

    PermissionStatus status;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      String androidVersion = androidInfo.version.release;
      debugPrint("Android Version $androidVersion");

      if (int.parse(androidVersion) >= 11) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        await Permission.storage.request();
        permissionFound.value = false;
        return;
      }

      if (status.isGranted) {
        final String directoryPath = whatsAppType.value == "WhatsAppB" ? WhatsAppPath.whatsappBDir : WhatsAppPath.whatsappDir;
        final directory = Directory(directoryPath);

        if (directory.existsSync()) {
          final items = await directory.list().toList();
          allList.value = items.where((element) => element.path.endsWith(".jpg") || element.path.endsWith(".mp4")).toList();
          debugPrint("Files $allList");
        } else {
          debugPrint("WhatsApp Directory Not Found");
        }
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
        permissionFound.value = false;
      }
    }
  }
}
