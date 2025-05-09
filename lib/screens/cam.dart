import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:osm_bingo/dao/team.dart';
import 'package:osm_bingo/in_range_checker.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      final controller = CameraController(firstCamera, ResolutionPreset.high);
      final initFuture = controller.initialize();

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _initializeControllerFuture = initFuture;
      });
    } catch (e, stack) {
      log('Error initializing camera: $e\n$stack');
    }
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      final uri = Uri.parse(
        'http://bingo.waltervanderbroek.nl:5000/api/upload',
      );
      var request = http.MultipartRequest('POST', uri);

      var pic = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(pic);
      request.fields['username'] = TeamDao.nameWithUuid;

      var response = await request.send();

      if (response.statusCode == 200) {
        log('Image uploaded successfully');
      } else {
        final responseBody = await response.stream.bytesToString();
        log(
          'Failed to upload image. Status: ${response.statusCode}, Body: $responseBody',
        );
      }
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body:
          _initializeControllerFuture == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(child: CameraPreview(_controller!));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller!.takePicture();
            await Gal.putImage(image.path);

            File imageFile = File(image.path);
            await uploadImage(imageFile);

            if (!context.mounted) return;
            final Position position = await Geolocator.getCurrentPosition();

            InRangeChecker().checkLocation(
              position.latitude,
              position.longitude,
              fromCamera: true,
            );
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            log('Error taking picture: $e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// This widget displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
