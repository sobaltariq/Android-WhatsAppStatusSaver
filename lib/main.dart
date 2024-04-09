import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/provider/getStatusProvider.dart';
import 'package:whats_app/provider/theme_manager.dart';
import 'package:whats_app/routes/my_routes.dart';
import 'package:whats_app/screens/home.dart';
import 'package:whats_app/screens/splash_screen.dart';

import 'colors/all_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetStatusProvider()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          log("theme ${themeManager.isDarkMode}");
          return MaterialApp(
            themeMode:
                themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return child!;
            },
            initialRoute: MyRoutes.splashRoute,
            routes: {
              MyRoutes.splashRoute: (context) => const SplashScreen(),
              MyRoutes.homeRoute: (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
