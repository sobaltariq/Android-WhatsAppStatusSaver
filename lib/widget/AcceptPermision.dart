import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app/colors/all_colors.dart';

class AcceptAPermission extends StatelessWidget {
  const AcceptAPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Permission Not Found"),
          const Text("Please Allow the Storage Permission"),
          InkWell(
            onTap: () {
              openAppSettings();
              // Navigator.pop(context);
            },
            child: const Text(
              "Open Setting",
              style: TextStyle(color: MyColors.lightGreenColor),
            ),
          )
        ],
      )),
    );
  }
}
