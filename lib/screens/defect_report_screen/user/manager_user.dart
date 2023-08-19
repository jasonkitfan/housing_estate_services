import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widget/defects/view_pending_list.dart';
import '../../../provider/defect_report_provider.dart';
import '../../../custom_widget/defects/monthly_dashboard.dart';
import '../../../custom_widget/defects/routine_tasks.dart';
import '../../../custom_widget/defects/view_complete_cases.dart';
import '../../../custom_widget/defects/view_on_progress_list.dart';
import '../../../custom_widget/defects/k_defect_text_style.dart';

class ManagerUserDefectScreen extends StatefulWidget {
  const ManagerUserDefectScreen({Key? key}) : super(key: key);

  @override
  State<ManagerUserDefectScreen> createState() =>
      _ManagerUserDefectScreenState();
}

class _ManagerUserDefectScreenState extends State<ManagerUserDefectScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .adminDefectInfoInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pendingList = Provider.of<DefectReportProvider>(context).pendingIssue;
    var onProgressList =
        Provider.of<DefectReportProvider>(context).onProgressIssue;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 150,
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) => const AdminViewPending());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${pendingList.length}", style: kPendingNumber),
                        Text(
                          "Pending",
                          style: kPendingText,
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) => const AdminViewOnProgress());
                  },
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${onProgressList.length}",
                          style: kProgressingNumber,
                        ),
                        Text(
                          "On Progress",
                          style: kProgressingText,
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
          const AdminViewCompleteCases(),
          const SizedBox(height: 10),
          const AdminMonthlyDashboard(),
          const SizedBox(height: 30),
          const DailyRoutineTask(isAdmin: true)
        ],
      ),
    ));
  }
}
