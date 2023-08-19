import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import '../../provider/defect_report_provider.dart';
import '../../custom_widget/defects/preview_button.dart';
import '../../custom_widget/defects/report_submit_button.dart';
import 'camera_view.dart';

class InsertDefectReport extends StatefulWidget {
  const InsertDefectReport({Key? key}) : super(key: key);

  @override
  State<InsertDefectReport> createState() => _InsertDefectReportState();
}

class _InsertDefectReportState extends State<InsertDefectReport> {
  final _textLocationController = TextEditingController();
  final _textDescriptionController = TextEditingController();
  final _focusNodeLocation = FocusNode();
  final _focusNodeDescription = FocusNode();

  late double keyboardBottomPadding = MediaQuery.of(context).viewInsets.bottom;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textLocationController.text =
        Provider.of<DefectReportProvider>(context, listen: false)
            .defectLocation;
    _textDescriptionController.text =
        Provider.of<DefectReportProvider>(context, listen: false)
            .defectDescription;
    super.initState();
  }

  @override
  void dispose() {
    _textLocationController.dispose();
    _textDescriptionController.dispose();
    _focusNodeLocation.dispose();
    _focusNodeDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
                alignment: Alignment.topLeft, child: Text("Report Defects")),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      onChanged: (location) =>
                          Provider.of<DefectReportProvider>(context,
                                  listen: false)
                              .setLocation(location),
                      controller: _textLocationController,
                      focusNode: _focusNodeLocation,
                      decoration: const InputDecoration(
                          labelText: "Location",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 3))),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        _focusNodeLocation.unfocus();
                        _focusNodeDescription.requestFocus();
                      },
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'Please enter the location';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      maxLines: 5,
                      onChanged: (description) =>
                          Provider.of<DefectReportProvider>(context,
                                  listen: false)
                              .setDescription(description),
                      focusNode: _focusNodeDescription,
                      controller: _textDescriptionController,
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 3))),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        _focusNodeDescription.unfocus();
                      },
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'Please enter the defect information';
                        }
                        return null;
                      }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Consumer<DefectReportProvider>(builder: (context, defect, child) {
              if (defect.defectImages.isEmpty) {
                return const SizedBox();
              } else {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      showDialog(
                          useSafeArea: false,
                          context: context,
                          builder: (BuildContext context) => Stack(
                                children: [
                                  SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Image.file(
                                      File(defect.defectImages[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      child: Row(
                                        children: [
                                          PreviewButton(
                                            buttonText: "Return",
                                            icon:
                                                Icons.keyboard_return_outlined,
                                            color: Colors.black,
                                            callback: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          PreviewButton(
                                              buttonText: "Remove",
                                              icon:
                                                  Icons.delete_forever_outlined,
                                              color: Colors.red,
                                              callback: () {
                                                Provider.of<DefectReportProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeImage(index);
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ));
                    },
                    child: Image.file(
                      File(defect.defectImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  itemCount: defect.defectImages.length,
                );
              }
            }),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CameraView(),
                          fullscreenDialog: true));
                },
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ReportSubmitButton(
              formKey: _formKey,
            )
          ],
        ),
      ),
    );
  }
}
