import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'all_images_screen.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  saveToDir(imagePath);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Image saved!"),
                  ));
                },
                child: const Icon(Icons.save),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllImagesScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.image),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveToDir(String imagePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageFile = File(imagePath);
    final newDir = Directory('${appDir.path}/saved_images');
    if (!await newDir.exists()) {
      await newDir.create(recursive: true);
    }
    final newFilePath = '${newDir.path}/${imageFile.path.split('/').last}';
    final newFile = File(newFilePath);
    if (!await newFile.exists()) {
      await newFile.create(recursive: true);
    }
    await imageFile.copy(newFile.path);
  }
}
