import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widget/defects/reject_defects_button.dart';
import '../../custom_widget/defects/progress_time_line.dart';
import '../../provider/defect_report_provider.dart';

class AdminViewPendingAndProgressingInfo extends StatefulWidget {
  const AdminViewPendingAndProgressingInfo(
      {Key? key,
      required this.defectInfo,
      this.isProgressing = false,
      this.isCompleted = false})
      : super(key: key);

  final Map<String, dynamic> defectInfo;
  final bool isProgressing;
  final bool isCompleted;

  @override
  State<AdminViewPendingAndProgressingInfo> createState() =>
      _AdminViewPendingAndProgressingInfoState();
}

class _AdminViewPendingAndProgressingInfoState
    extends State<AdminViewPendingAndProgressingInfo> {
  late String _input;
  String _additionInput = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<String> worker;

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .getWorkerList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    worker = Provider.of<DefectReportProvider>(context).workerList;

    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Reported by: "),
                Text(widget.defectInfo["reporter"]),
              ],
            ),
            Row(
              children: [
                const Text("Reported on: "),
                Text(widget.defectInfo["date"]),
              ],
            ),
            Row(
              children: [
                const Text("Location: "),
                Text(widget.defectInfo["location"]),
              ],
            ),
            Row(
              children: [
                const Text("Description: "),
                Text(widget.defectInfo["description"]),
              ],
            ),
            const SizedBox(height: 50),
            widget.defectInfo["worker"] != null
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Assigned Worker: "),
                        ...widget.defectInfo["worker"]
                            .map((worker) => Text(worker))
                            .toList(),
                      ],
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 50),
            if (widget.defectInfo["remark"] != null)
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("remark"),
                    Text(widget.defectInfo["remark"]),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    Image.network(widget.defectInfo["imagePath"][index]),
                separatorBuilder: (c, i) => const SizedBox(height: 10),
                itemCount: widget.defectInfo["imagePath"].length),
            const SizedBox(height: 50),
            !widget.isProgressing
                ? SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: AdminRejectButton(
                          docId: widget.defectInfo["id"],
                        )),
                        const SizedBox(width: 5),
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo),
                          onPressed: () {},
                          child: const Text("Duplicated"),
                        )),
                        const SizedBox(width: 5),
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            Provider.of<DefectReportProvider>(context,
                                    listen: false)
                                .getWorkerList();
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Container(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 10, right: 10),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                  "Additional Information (Optional)"),
                                              const SizedBox(height: 20),
                                              Form(
                                                child: TextFormField(
                                                  onChanged: (e) {
                                                    _additionInput = e;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Message',
                                                    border:
                                                        OutlineInputBorder(),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 8),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 30),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Assign To: "),
                                                  const SizedBox(width: 10),
                                                  worker.isEmpty
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              worker.length,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              CheckboxListTile(
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                            title: Text(
                                                                worker[index]),
                                                            value: Provider.of<
                                                                        DefectReportProvider>(
                                                                    context)
                                                                .workerChecked[index],
                                                            onChanged:
                                                                (bool? value) {
                                                              Provider.of<DefectReportProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .checkWorker(
                                                                      index);
                                                            },
                                                          ),
                                                        )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                      "Maintenance Type: "),
                                                  const SizedBox(width: 20),
                                                  DropdownButton<String>(
                                                    value: Provider.of<
                                                                DefectReportProvider>(
                                                            context)
                                                        .dropdownValue,
                                                    icon: const Icon(
                                                        Icons.arrow_downward),
                                                    elevation: 16,
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                    ),
                                                    onChanged: (String? value) {
                                                      Provider.of<DefectReportProvider>(
                                                              context,
                                                              listen: false)
                                                          .changeDropdownValue(
                                                              value!);
                                                    },
                                                    items: Provider.of<
                                                                DefectReportProvider>(
                                                            context,
                                                            listen: false)
                                                        .dropDownList
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Provider.of<DefectReportProvider>(
                                                              context,
                                                              listen: false)
                                                          .acceptDefect(
                                                              widget.defectInfo[
                                                                  "id"],
                                                              _additionInput);
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text("Accept")),
                                              ),
                                              const SizedBox(height: 100)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          child: const Text("Accept"),
                        ))
                      ],
                    ),
                  )
                : widget.defectInfo["status"] == "pending" ||
                        widget.defectInfo["status"] == "rejected"
                    ? const SizedBox()
                    : ProgressTimeLine(docId: widget.defectInfo["id"]),
            widget.defectInfo["status"] == "rejected"
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("reject reason:"),
                        const SizedBox(height: 5),
                        Text(widget.defectInfo["reason"])
                      ],
                    ),
                  )
                : const SizedBox(),
            widget.isCompleted
                ? const SizedBox()
                : widget.isProgressing
                    ? SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              top: 20,
                                              left: 10,
                                              right: 10,
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text("Update"),
                                              const SizedBox(height: 20),
                                              Form(
                                                key: _formKey,
                                                child: TextFormField(
                                                    maxLines: 3,
                                                    onChanged: (e) {
                                                      _input = e;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Message',
                                                      border:
                                                          OutlineInputBorder(),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 8),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value == "") {
                                                        return 'Please enter the message';
                                                      }
                                                      return null;
                                                    }),
                                              ),
                                              const SizedBox(height: 20),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      Provider.of<DefectReportProvider>(
                                                              context,
                                                              listen: false)
                                                          .updateMaintenanceHistory(
                                                              "update",
                                                              widget.defectInfo[
                                                                  "id"],
                                                              message: _input);
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text("Submit")),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        ));
                              },
                              child: const Text("update"),
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('Confirmation'),
                                          content: const Text(
                                              'This task is completely finished?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'No'),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'Yes');
                                                Provider.of<DefectReportProvider>(
                                                        context,
                                                        listen: false)
                                                    .updateMaintenanceHistory(
                                                        "complete",
                                                        widget
                                                            .defectInfo["id"]);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ));
                              },
                              child: const Text("complete"),
                            )),
                          ],
                        ),
                      )
                    : const SizedBox()
          ],
        ),
      ),
    );
  }
}
