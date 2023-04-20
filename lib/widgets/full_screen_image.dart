import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageScreen extends StatefulWidget {
  final File imageFile;
  final List<File> imageFiles;
  final Function(File) onDelete;
  final int index;

  const FullScreenImageScreen(
      this.imageFile, this.imageFiles, this.onDelete, {super.key, required this.index});

  @override
  FullScreenImageScreenState createState() => FullScreenImageScreenState();
}

class FullScreenImageScreenState extends State<FullScreenImageScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  Future<void> _deleteImage() async {
    await widget.onDelete(widget.imageFiles[_currentIndex]);
    Navigator.pop(context, true);
  }

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.imageFiles.length) %
          widget.imageFiles.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _deleteImage,
            icon: const Icon(Icons.delete),
            tooltip: "Delete Image",
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _previousImage();
          } else if (details.primaryVelocity! < 0) {
            _nextImage();
          }
        },
        child: PhotoViewGallery.builder(
          itemCount: widget.imageFiles.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(widget.imageFiles[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          pageController: PageController(initialPage: _currentIndex),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.imageFiles.length;
    });
  }
}
