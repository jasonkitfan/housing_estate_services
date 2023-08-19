import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_pending_or_progressing_info.dart';
import '../../custom_widget/defects/k_defect_text_style.dart';
import '../../provider/defect_report_provider.dart';
import 'my_list_tile.dart';

class AdminViewCompleteCases extends StatelessWidget {
  const AdminViewCompleteCases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var completeCase =
        Provider.of<DefectReportProvider>(context).completedCases;

    return SizedBox(
      width: double.infinity,
      height: 150,
      child: GestureDetector(
        onTap: () {
          showDialog(
              useSafeArea: false,
              context: context,
              builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text("Completed Cases"),
                    ),
                    body: ListView.separated(
                      separatorBuilder: (c, i) => const SizedBox(height: 10),
                      itemCount: completeCase.length,
                      itemBuilder: (context, index) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  AdminViewPendingAndProgressingInfo(
                                    defectInfo: completeCase[index],
                                    isCompleted: true,
                                    isProgressing: true,
                                  ));
                        },
                        child: MyListTile(
                          date: completeCase[index]["date"],
                          location: completeCase[index]["location"],
                          description: completeCase[index]["description"],
                          status: completeCase[index]["status"],
                          imagePath: completeCase[index]["imagePath"][0],
                        ),
                      ),
                    ),
                  ));
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${completeCase.length}",
                style: kCompletedNumber,
              ),
              const SizedBox(height: 10),
              Text(
                "Completed",
                style: kCompletedText,
              )
            ],
          ),
        ),
      ),
    );
  }
}
