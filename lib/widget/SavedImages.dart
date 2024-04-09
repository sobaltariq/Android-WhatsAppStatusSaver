import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/images/image_view.dart';

class SavedImages extends StatelessWidget {
  var imagePath;

  SavedImages({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(imagePath: imagePath.path),
            ));
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          // color: MyColors.secondaryColor,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: FileImage(File(imagePath.path)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
