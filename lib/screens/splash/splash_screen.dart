import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whatsapp_status_saver/routes/app_routes.dart';
import 'package:whatsapp_status_saver/services/whatsapp_service.dart';

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
    _splashChange();
  }

  void _splashChange() async {
    // await WhatsAppService.createAppFolders();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
