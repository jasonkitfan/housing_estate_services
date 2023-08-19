import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/defect_report_provider.dart';

class ReportSubmitButton extends StatefulWidget {
  const ReportSubmitButton({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  State<ReportSubmitButton> createState() => _ReportSubmitButtonState();
}

class _ReportSubmitButtonState extends State<ReportSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                Provider.of<DefectReportProvider>(context, listen: false)
                    .submitReport();
                Navigator.of(context).pop();
              }
            },
            child: const Text("Report")));
  }
}
