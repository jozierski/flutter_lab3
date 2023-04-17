import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatefulWidget {
  final File imageFile;
  final List<File> imageFiles;
  final Function(File) onDelete;

  FullScreenImageScreen(this.imageFile, this.imageFiles, this.onDelete);

  @override
  FullScreenImageScreenState createState() => FullScreenImageScreenState();
}

class FullScreenImageScreenState extends State<FullScreenImageScreen> {
  Future<void> _deleteImage() async {
    await widget.onDelete(widget.imageFile);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            InteractiveViewer(
              child: Image.file(
                widget.imageFile,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              height: 80,
              child: ElevatedButton(
                onPressed: _deleteImage,
                child: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
