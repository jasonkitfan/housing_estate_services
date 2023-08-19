import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/defect_report_screen/user/manager_user.dart';
import '../../screens/defect_report_screen/report_defect_screen.dart';
import '../../screens/defect_report_screen/user/engineering_user.dart';
import '../../provider/defect_report_provider.dart';
import '../../screens/defect_report_screen/user/normal_user.dart';

class DefectMainScreen extends StatefulWidget {
  const DefectMainScreen({Key? key}) : super(key: key);

  @override
  State<DefectMainScreen> createState() => _DefectMainScreenState();
}

class _DefectMainScreenState extends State<DefectMainScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .getUserRole());
    super.initState();
  }

  final List screen = [
    const ManagerUserDefectScreen(),
    const EngineeringUserDefectScreen(),
    const NormalUserDefectScreen()
  ];

  @override
  Widget build(BuildContext context) {
    var role = Provider.of<DefectReportProvider>(context).userRole;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Defects Record",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: role != null
          ? screen[getRole(role)]
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => const InsertDefectReport()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

int getRole(String role) {
  switch (role) {
    case 'admin':
      return 0;
    case 'engineering':
      return 1;
    case 'normal_user':
      return 2;
    default:
      return 2;
  }
}
