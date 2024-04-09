import 'package:flutter/material.dart';

import '../../colors/all_colors.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whats App Status Downloader"),
      ),
      body: Container(

      ),
    );
  }
}
