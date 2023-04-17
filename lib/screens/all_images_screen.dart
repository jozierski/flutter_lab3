import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/full_screen_image.dart';

class AllImagesScreen extends StatefulWidget {
  @override
  AllImagesScreenState createState() => AllImagesScreenState();
}

class AllImagesScreenState extends State<AllImagesScreen> {
  late Directory _imageDir;
  late List<File> _imageFiles;

  @override
  void initState() {
    super.initState();
    _getImagesFromDir();
  }

  Future<void> _getImagesFromDir() async {
    _imageDir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/saved_images');
    _imageFiles = await _imageDir
        .list()
        .where((element) => element is File)
        .map<File>((element) => element as File)
        .toList();
    setState(() {});
  }

  Future<void> _deleteImage(File imageFile) async {
    await imageFile.delete();
    setState(() {
      _imageFiles.remove(imageFile);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Image deleted!"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Images'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: _imageFiles.map((file) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImageScreen(file, _imageFiles, _deleteImage),
                ),
              );
            },
            child: Card(
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
