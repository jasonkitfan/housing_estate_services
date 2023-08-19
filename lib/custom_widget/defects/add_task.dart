import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/defect_report_provider.dart';

class ModifyTask extends StatefulWidget {
  const ModifyTask({Key? key}) : super(key: key);

  @override
  State<ModifyTask> createState() => _ModifyTaskState();
}

class _ModifyTaskState extends State<ModifyTask> {
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _updateRemoveKey = GlobalKey<FormState>();

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some input';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var task = Provider.of<DefectReportProvider>(context).dailyTask;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modify Task"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    String newTaskTitle = "";
                    String newTaskInfo = "";
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Container(
                              margin: const EdgeInsets.all(10),
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _addFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Add Task"),
                                      TextFormField(
                                        onChanged: (e) {
                                          newTaskTitle = e;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task Title',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                        ),
                                        validator: _validateInput,
                                      ),
                                      const SizedBox(height: 30),
                                      TextFormField(
                                        onChanged: (e) {
                                          newTaskInfo = e;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task Information',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                        ),
                                        validator: _validateInput,
                                      ),
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              if (_addFormKey.currentState!
                                                  .validate()) {
                                                Provider.of<DefectReportProvider>(
                                                        context,
                                                        listen: false)
                                                    .addTask(newTaskTitle,
                                                        newTaskInfo);
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: const Text("Add Task")),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  child: const Icon(Icons.add)))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.separated(
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemCount: task.length,
            itemBuilder: (context, index) => ListTile(
                  leading: Text("Task ${index + 1}"),
                  title: Text("${task[index]["title"]}"),
                  subtitle: Text("${task[index]["detail"]}"),
                  trailing: GestureDetector(
                      onTap: () {
                        String taskTitle = task[index]["title"];
                        String taskInfo = task[index]["detail"];
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: _updateRemoveKey,
                                      child: Column(
                                        children: [
                                          const Text("Modify Daily Task"),
                                          const SizedBox(height: 30),
                                          TextFormField(
                                            initialValue: taskTitle,
                                            onChanged: (e) {
                                              taskTitle = e;
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Task Title',
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                            ),
                                            validator: _validateInput,
                                          ),
                                          const SizedBox(height: 30),
                                          TextFormField(
                                            initialValue: taskInfo,
                                            onChanged: (e) {
                                              taskInfo = e;
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Task Information',
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                            ),
                                            validator: _validateInput,
                                          ),
                                          const SizedBox(height: 30),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        if (_updateRemoveKey
                                                            .currentState!
                                                            .validate()) {
                                                          Provider.of<DefectReportProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .modifyDailyTask(
                                                                  index,
                                                                  taskTitle,
                                                                  taskInfo);
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child:
                                                          const Text("Update")),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                    child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red),
                                                  onPressed: () {
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Remove Task'),
                                                        content: const Text(
                                                            'Do you really want to remove this task'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'No'),
                                                            child: const Text(
                                                                'No'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Provider.of<DefectReportProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .removeDailyTask(
                                                                      index);
                                                              Navigator.pop(
                                                                  context,
                                                                  'Yes');
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: const Text("Delete"),
                                                ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      },
                      child: const Icon(Icons.mode_edit_outline_outlined)),
                )),
      ),
    );
  }
}
