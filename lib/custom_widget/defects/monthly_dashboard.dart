import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widget/defects/k_defect_text_style.dart';
import '../../provider/defect_report_provider.dart';

class AdminMonthlyDashboard extends StatefulWidget {
  const AdminMonthlyDashboard({Key? key}) : super(key: key);

  @override
  State<AdminMonthlyDashboard> createState() => _AdminMonthlyDashboardState();
}

class _AdminMonthlyDashboardState extends State<AdminMonthlyDashboard> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DefectReportProvider>(context, listen: false)
            .getMonthlyData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var section = Provider.of<DefectReportProvider>(context).sections;
    var indicator = Provider.of<DefectReportProvider>(context).indicator;

    PieChartData data = PieChartData(
      sections: section,
    );

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: double.infinity,
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
              Text("Monthly Information", style: kTitle),
              const SizedBox(height: 30),
              section.isEmpty || section.any((element) => element.value.isNaN)
                  ? const Center(child: Text("No data available"))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 200, width: 200, child: PieChart(data)),
                        const SizedBox(width: 20),
                        IntrinsicWidth(
                          child: Column(
                            children: [
                              ...section.map((cat) => buildIndicator(
                                  cat.color as MaterialColor,
                                  indicator[section.indexOf(cat)]))
                            ],
                          ),
                        )
                      ],
                    )
            ],
          ),
        ));
  }

  Widget buildIndicator(MaterialColor color, String label) {
    return Row(
      children: [
        Container(
          color: color,
          width: 10,
          height: 3,
        ),
        const SizedBox(width: 3),
        Text(label)
      ],
    );
  }
}
