import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widget/defects/add_task.dart';
import '../../provider/defect_report_provider.dart';
import 'k_defect_text_style.dart';

class DailyRoutineTask extends StatefulWidget {
  const DailyRoutineTask({Key? key, this.isAdmin = false}) : super(key: key);

  final bool isAdmin;

  @override
  State<DailyRoutineTask> createState() => _DailyRoutineTaskState();
}

class _DailyRoutineTaskState extends State<DailyRoutineTask> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .getDailyTask());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dailyTask = Provider.of<DefectReportProvider>(context).dailyTask;

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Daily Routine Task", style: kTitle),
                  const SizedBox(width: 20),
                  if (widget.isAdmin)
                    GestureDetector(
                      child: const Icon(Icons.mode_edit_outline_outlined),
                      onTap: () {
                        showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (context) => const ModifyTask());
                      },
                    )
                ],
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: dailyTask.length,
                  itemBuilder: (context, index) => ListTile(
                        leading: Text("Task ${index + 1}"),
                        title: Text("${dailyTask[index]["title"]}"),
                        subtitle: Text("${dailyTask[index]["detail"]}"),
                      )),
            ],
          ),
        ));
  }
}
