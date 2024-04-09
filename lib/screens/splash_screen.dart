import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../routes/my_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashChange();
    createFolder();
  }

  void splashChange() async {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
    });
  }

  // create folder
  void createFolder() async {
    // String directory = (await getApplicationDocumentsDirectory()).path;
    final whatsappDir = await "/storage/emulated/0/My App/WhatsApp";
    final whatsappBDir = await "/storage/emulated/0/My App/WhatsApp Business";

    if (await Directory(whatsappDir).exists() != true &&
        await Directory(whatsappBDir).exists() != true) {
      debugPrint("Directory not exist");
      Directory(whatsappDir).createSync(recursive: true);
      Directory(whatsappBDir).createSync(recursive: true);
      debugPrint("Directory Create $whatsappDir and $whatsappBDir");
//do your work
    } else {
      print("Directory exist");

//do your work
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("WhatsApp Status Downloader")),
    );
  }
}
