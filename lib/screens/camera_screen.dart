import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'all_images_screen.dart';
import 'display_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  CameraScreenState() {
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _controller.initialize();
    await _controller.setFlashMode(FlashMode.off);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Transform.scale(
              scale: 1.0,
              child: Center(
                child: Column(
                  children: [
                    CameraPreview(_controller),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 400,
                      height: 80,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _initializeControllerFuture;

                          final XFile pictureFile =
                              await _controller.takePicture();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                  imagePath: pictureFile.path),
                            ),
                          );
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
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
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
