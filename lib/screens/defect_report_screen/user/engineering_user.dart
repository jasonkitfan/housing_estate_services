import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/defect_report_provider.dart';
import '../../../custom_widget/defects/routine_tasks.dart';
import '../../../custom_widget/defects/view_pending_or_progressing_info.dart';
import '../../../custom_widget/defects/my_list_tile.dart';

class EngineeringUserDefectScreen extends StatefulWidget {
  const EngineeringUserDefectScreen({Key? key}) : super(key: key);

  @override
  State<EngineeringUserDefectScreen> createState() =>
      _EngineeringUserDefectScreenState();
}

class _EngineeringUserDefectScreenState
    extends State<EngineeringUserDefectScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .getOnProgressIssueForWorker());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List progressingIssues =
        Provider.of<DefectReportProvider>(context).onProgressIssue;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const DailyRoutineTask(),
          progressingIssues.isNotEmpty
              ? SizedBox(
                  width: double.infinity,
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AdminViewPendingAndProgressingInfo(
                                          isProgressing: true,
                                          defectInfo:
                                              progressingIssues[index]));
                            },
                            child: MyListTile(
                              date: progressingIssues[index]["date"],
                              location: progressingIssues[index]["location"],
                              description: progressingIssues[index]
                                  ["description"],
                              status: progressingIssues[index]["status"],
                              imagePath: progressingIssues[index]["imagePath"]
                                  [0],
                            ),
                          ),
                      separatorBuilder: (context, index) =>
                          const Divider(thickness: 3),
                      itemCount: progressingIssues.length),
                )
              : const SizedBox(),
        ],
      ),
    ));
  }
}
