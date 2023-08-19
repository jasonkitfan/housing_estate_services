import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widget/defects/view_pending_or_progressing_info.dart';
import '../../../custom_widget/defects/my_list_tile.dart';
import '../../../provider/defect_report_provider.dart';

class NormalUserDefectScreen extends StatefulWidget {
  const NormalUserDefectScreen({Key? key}) : super(key: key);

  @override
  State<NormalUserDefectScreen> createState() => _NormalUserDefectScreenState();
}

class _NormalUserDefectScreenState extends State<NormalUserDefectScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .getDefectReports());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List reportList = Provider.of<DefectReportProvider>(context).defectReport;

    return reportList.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
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
                                    defectInfo: reportList[index],
                                    isProgressing: true,
                                    isCompleted: true,
                                  ));
                        },
                        child: MyListTile(
                          date: reportList[index]["date"],
                          location: reportList[index]["location"],
                          description: reportList[index]["description"],
                          status: reportList[index]["status"],
                          imagePath: reportList[index]["imagePath"][0],
                        ),
                      ),
                  separatorBuilder: (context, index) =>
                      const Divider(thickness: 3),
                  itemCount: reportList.length),
            ),
          )
        : const SizedBox();
  }
}
