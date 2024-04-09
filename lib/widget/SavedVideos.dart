import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app/screens/videos/video_view.dart';

import '../colors/all_colors.dart';

class SavedVideos extends StatelessWidget {
  var videoPath;

  var getThumbnail;

  SavedVideos({super.key, required this.videoPath, required this.getThumbnail});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getThumbnail(videoPath.path),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoView(videoPath: videoPath.path),
                  ));
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                // color: MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: FileImage(File(snapshot.data.toString())),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error generating thumbnail: ${snapshot.error}',
              style: const TextStyle(color: MyColors.blueColor),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
