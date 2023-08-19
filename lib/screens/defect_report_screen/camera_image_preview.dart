import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';

import '../../provider/defect_report_provider.dart';

class CameraImagePreview extends StatefulWidget {
  const CameraImagePreview({Key? key, required this.filePath})
      : super(key: key);

  final String filePath;

  @override
  State<CameraImagePreview> createState() => _CameraImagePreviewState();
}

class _CameraImagePreviewState extends State<CameraImagePreview> {
  void addToProvider() {
    Provider.of<DefectReportProvider>(context, listen: false)
        .addCameraImage(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              child: Image.file(File(widget.filePath))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () async {
                    GallerySaver.saveImage(widget.filePath);
                    addToProvider();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
