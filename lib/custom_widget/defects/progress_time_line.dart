import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../provider/defect_report_provider.dart';
import '../../custom_widget/defects/k_defect_text_style.dart';

class ProgressTimeLine extends StatefulWidget {
  const ProgressTimeLine({Key? key, required this.docId}) : super(key: key);

  final String docId;

  @override
  State<ProgressTimeLine> createState() => _ProgressTimeLineState();
}

class _ProgressTimeLineState extends State<ProgressTimeLine> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .getMaintenanceHistory(widget.docId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var progressHistory =
        Provider.of<DefectReportProvider>(context).maintenanceHistory;

    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Progress Time Line",
              style: kProgressTimeLine,
            )),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: progressHistory.length,
            itemBuilder: (context, index) => SizedBox(
                  height: 100,
                  child: TimelineTile(
                    indicatorStyle: const IndicatorStyle(width: 15, height: 15),
                    isFirst: index == 0 ? true : false,
                    isLast: progressHistory[index]["message"] == "complete"
                        ? true
                        : false,
                    axis: TimelineAxis.vertical,
                    alignment: TimelineAlign.manual,
                    lineXY: 0.3,
                    startChild: Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(progressHistory[index]["date"].split(" ")[0]),
                          Text(progressHistory[index]["date"].split(" ")[1])
                        ],
                      ),
                    ),
                    endChild: Container(
                      margin: const EdgeInsets.only(left: 5),
                      constraints: const BoxConstraints(
                        minWidth: 120,
                      ),
                      child: Text(progressHistory[index]["message"]),
                    ),
                  ),
                )),
        progressHistory.isNotEmpty &&
                progressHistory.last["message"] != "complete"
            ? SizedBox(
                height: 100,
                child: TimelineTile(
                  isLast: true,
                  indicatorStyle: const IndicatorStyle(width: 15, height: 15),
                  axis: TimelineAxis.vertical,
                  alignment: TimelineAlign.manual,
                  lineXY: 0.3,
                  startChild: Container(
                    margin: const EdgeInsets.only(right: 5),
                  ),
                  endChild: Container(
                    margin: const EdgeInsets.only(left: 5),
                    constraints: const BoxConstraints(
                      minWidth: 120,
                    ),
                    child: const Text("continuing"),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
