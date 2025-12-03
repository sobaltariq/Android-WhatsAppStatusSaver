import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_status_saver/controllers/theme_controller.dart';
import 'package:whatsapp_status_saver/routes/app_routes.dart';
import 'package:whatsapp_status_saver/screens/home/home.dart';
import 'package:whatsapp_status_saver/screens/splash/splash_screen.dart';
import 'colors/all_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(
      () => MaterialApp(
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return child!;
        },
        initialRoute: AppRoutes.splashRoute,
        routes: {
          AppRoutes.splashRoute: (context) => const SplashScreen(),
          AppRoutes.homeRoute: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
