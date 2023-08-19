import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widget/defects/my_list_tile.dart';
import '../../provider/defect_report_provider.dart';
import '../../custom_widget/defects/view_pending_or_progressing_info.dart';

class AdminViewOnProgress extends StatelessWidget {
  const AdminViewOnProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var onProgressIssue =
        Provider.of<DefectReportProvider>(context).onProgressIssue;

    return Scaffold(
      appBar: AppBar(
        title: const Text("On Progress Tasks"),
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (c, i) => const SizedBox(height: 10),
          itemCount: onProgressIssue.length,
          itemBuilder: (context, index) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AdminViewPendingAndProgressingInfo(
                        defectInfo: onProgressIssue[index],
                        isProgressing: true,
                      ));
            },
            child: MyListTile(
              date: onProgressIssue[index]["date"],
              location: onProgressIssue[index]["location"],
              description: onProgressIssue[index]["description"],
              status: onProgressIssue[index]["status"],
              imagePath: onProgressIssue[index]["imagePath"][0],
            ),
          ),
        ),
      ),
    );
  }
}
