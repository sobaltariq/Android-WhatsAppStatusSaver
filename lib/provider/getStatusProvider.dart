import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/whatsapp_path.dart';

class GetStatusProvider extends ChangeNotifier {
  List<FileSystemEntity> _imagesList = [];
  List<FileSystemEntity> _videosList = [];
  List<FileSystemEntity> _allList = [];

  List<FileSystemEntity> get getImages => _imagesList;
  List<FileSystemEntity> get getVideos => _videosList;
  List<FileSystemEntity> get getAllStatus => _allList;

  bool _ColorType = false;

  String _whatsAppType = "WhatsApp";

  String get whatsAppType => _whatsAppType;

  void setWhatsAppType(String value) {
    _whatsAppType = value;
    notifyListeners();
  }

  // true for whatsapp false for business
  bool _whatsAppPath = true;
  bool get whatsAppPath => _whatsAppPath;

  void setWhatsAppPath(bool value) {
    _whatsAppPath = value;
    notifyListeners();
  }

  bool _permissionFound = false;
  bool get permissionFound => _permissionFound;

  Future<void> getStatus(String extensions) async {
    log("Get Status");
    PermissionStatus status;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      String androidVersion = androidInfo.version.release;
      debugPrint("Android Version $androidVersion");
      if (int.parse(androidVersion) >= 11) {
        status = await Permission.manageExternalStorage.request();
      } else if (int.parse(androidVersion) <= 11) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        await Permission.storage.request();
        log("Permission Denied");
        _permissionFound = false;
        notifyListeners(); // Notify listeners of the state change
        return;
      }

      if (status.isGranted) {
        final String directoryPath;
        if (whatsAppType == "WhatsAppB") {
          directoryPath = await WhatsAppPath.getWhatsAppBPath();
          if (directoryPath.isNotEmpty) {
            debugPrint("WhatsApp B Path Found");
          } else {
            debugPrint("WhatsApp B Path Not Found");
          }
        } else {
          directoryPath = await WhatsAppPath.getWhatsAppPath();
          if (directoryPath.isNotEmpty) {
            debugPrint("WhatsApp Path Found");
          } else {
            debugPrint("WhatsApp Path Not Found");
          }
        }
        final directory = Directory(directoryPath);

        if (directory.existsSync()) {
          final items = await directory.list().toList();

          if (extensions == ".jpg") {
            _imagesList = items
                .where((element) => element.path.endsWith(".jpg"))
                .toList();
            log("PIC $_imagesList");
          }

          if (extensions == ".mp4") {
            _videosList = items
                .where((element) => element.path.endsWith(".mp4"))
                .toList();
            log("VID $_videosList");
          }
        } else {
          log("WhatsApp Directory Not Found"); // Notify listeners of the state change
        }

        _permissionFound = true;
        notifyListeners();
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
        _permissionFound = false;
        notifyListeners();
        log("Permission Denied: $permissionFound");
      }
    }
  }

  // to get saved in my app folder
  Future<void> getSaved(String extensions) async {
    log("Get Saved");

    PermissionStatus status;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      String androidVersion = androidInfo.version.release;
      debugPrint("Android Version $androidVersion");

      if (int.parse(androidVersion) >= 11) {
        status = await Permission.manageExternalStorage.request();
      } else if (int.parse(androidVersion) <= 11) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        await Permission.storage.request();
        _permissionFound = false;
        notifyListeners(); // Notify listeners of the state change
        return;
      }

      if (status.isGranted) {
        final String directoryPath;
        if (_whatsAppType == "WhatsAppB") {
          directoryPath = await "/storage/emulated/0/My App/WhatsApp Business";
          if (directoryPath.isNotEmpty) {
            debugPrint("WhatsApp B Path Found");
          } else {
            debugPrint("WhatsApp B Path Not Found");
          }
        } else {
          directoryPath = await "/storage/emulated/0/My App/WhatsApp";
          if (directoryPath.isNotEmpty) {
            debugPrint("WhatsApp B Path Found");
          } else {
            debugPrint("WhatsApp B Path Not Found");
          }
        }

        final directory = Directory(directoryPath);

        if (directory.existsSync()) {
          final items = await directory.list().toList();

          if (extensions == ".jpg" || extensions == ".jpg") {
            _allList = items
                .where((element) =>
                    element.path.endsWith(".jpg") ||
                    element.path.endsWith(".mp4"))
                .toList();
            notifyListeners();
            log("Files $_allList");
            // log("VID $_allList");
          }
        } else {
          log("WhatsApp Directory Not Found"); // Notify listeners of the state change
        }
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
        _permissionFound = false;
        notifyListeners(); // Notify listeners of the state change
      }
    }
  }
}
