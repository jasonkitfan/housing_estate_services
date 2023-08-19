import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/defect_report_provider.dart';
import 'camera_image_preview.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late bool flip = false;

  final picker = ImagePicker();
  List<XFile> imageList = [];

  @override
  void initState() {
    _initializeControllerFuture = cameraInit(flip);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future cameraInit(bool flip) async {
    final cameras = await availableCameras();
    final getCamera = cameras[flip ? 1 : 0];
    _controller = CameraController(
      getCamera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    return _controller.initialize();
  }

  void takePhoto(bool flip) async {
    var image = await _controller.takePicture();
    if (!mounted) {
      return;
    }

    /// flip the image from front camera
    if (flip) {
      List<int> imageBytes = await image.readAsBytes();
      img.Image? originalImage =
          img.decodeImage(Uint8List.fromList(imageBytes));
      img.Image fixedImage = img.flipHorizontal(originalImage!);
      File file = File(image.path);
      await file.writeAsBytes(
        img.encodeJpg(fixedImage),
        flush: true,
      );
    }

    goPreviewScreen(image.path);
  }

  void goPreviewScreen(String filePath) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraImagePreview(filePath: filePath),
            fullscreenDialog: true));
  }

  void pickImage() async {
    imageList = await picker.pickMultiImage();
    if (imageList.isEmpty) {
      return;
    }
    addGallery();
  }

  void addGallery() {
    Provider.of<DefectReportProvider>(context, listen: false)
        .addGalleryImages(imageList);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: double.infinity,
                      child: CameraPreview(_controller)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 30, top: 30),
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.cancel_outlined, size: 30)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => pickImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              height: 50,
                              width: 50,
                              child: const Icon(
                                Icons.image_outlined,
                                size: 40,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              takePhoto(flip);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              height: 70,
                              width: 70,
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 40,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              flip = !flip;
                              _initializeControllerFuture = cameraInit(flip);
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              height: 50,
                              width: 50,
                              child: const Icon(
                                Icons.flip_camera_ios_outlined,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
