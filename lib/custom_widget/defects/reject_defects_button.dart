import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/defect_report_provider.dart';

class AdminRejectButton extends StatefulWidget {
  const AdminRejectButton({Key? key, required this.docId}) : super(key: key);

  final String docId;

  @override
  State<AdminRejectButton> createState() => _AdminRejectButtonState();
}

class _AdminRejectButtonState extends State<AdminRejectButton> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _input = "";

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Reject",
                          style: TextStyle(fontSize: 20, color: Colors.red)),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                            maxLines: 3,
                            onChanged: (e) {
                              _input = e;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Reason',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                            ),
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Please enter the reason';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Provider.of<DefectReportProvider>(context,
                                      listen: false)
                                  .rejectDefect(widget.docId, _input);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("Confirm"))
                    ],
                  ),
                ));
      },
      child: const Text("Reject"),
    );
  }
}
