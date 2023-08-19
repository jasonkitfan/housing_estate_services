import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widget/defects/view_pending_or_progressing_info.dart';
import '../../provider/defect_report_provider.dart';
import 'my_list_tile.dart';

class AdminViewPending extends StatelessWidget {
  const AdminViewPending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pendingList = Provider.of<DefectReportProvider>(context).pendingIssue;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Issues"),
      ),
      body: ListView.separated(
        shrinkWrap: false,
        separatorBuilder: (c, i) => const SizedBox(height: 10),
        itemCount: pendingList.length,
        itemBuilder: (context, index) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AdminViewPendingAndProgressingInfo(
                    defectInfo: pendingList[index]));
          },
          child: MyListTile(
            date: pendingList[index]["date"],
            location: pendingList[index]["location"],
            description: pendingList[index]["description"],
            status: pendingList[index]["status"],
            imagePath: pendingList[index]["imagePath"][0],
          ),
        ),
      ),
    );
  }
}
