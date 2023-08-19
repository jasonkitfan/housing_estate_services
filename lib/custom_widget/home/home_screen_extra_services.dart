import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../provider/navigation_provider.dart";

class ExtraServices extends StatelessWidget {
  const ExtraServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ExtraServiceCard(
                  imagePath: "assets/images/services_list/lost_and_found.png",
                  text: "Lost and found",
                  color1: Colors.redAccent.withOpacity(0.3),
                  color2: Colors.orange.withOpacity(0.5),
                  index: NavigationIndex.lostAndFound.index,
                  number: 8,
                ),
                const SizedBox(height: 10),
                ExtraServiceCard(
                  imagePath: "assets/images/services_list/complaint_report.png",
                  text: "Detects Report",
                  color1: Colors.greenAccent.withOpacity(0.3),
                  color2: Colors.amberAccent.withOpacity(0.7),
                  index: NavigationIndex.complaintAndReport.index,
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                ExtraServiceCard(
                  imagePath: "assets/images/services_list/neighbour.png",
                  text: "Neighbour Interactive",
                  color1: Colors.purple.withOpacity(0.3),
                  color2: Colors.deepPurpleAccent.withOpacity(0.5),
                  index: NavigationIndex.neighbourInteractive.index,
                ),
                const SizedBox(height: 10),
                ExtraServiceCard(
                  imagePath:
                      "assets/images/services_list/customer_services.png",
                  text: "Management Office Inquiry",
                  color1: Colors.lightBlue.withOpacity(0.3),
                  color2: Colors.indigoAccent.withOpacity(0.5),
                  index: NavigationIndex.managementOfficeInquiry.index,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ExtraServiceCard extends StatelessWidget {
  const ExtraServiceCard(
      {Key? key,
      required this.text,
      required this.imagePath,
      required this.color1,
      required this.color2,
      required this.index,
      this.number})
      : super(key: key);

  final String text;
  final String imagePath;
  final int? number;
  final Color color1;
  final Color color2;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var switchPage = Provider.of<NavigationProvider>(context).changeIndex;
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: Colors.black, padding: EdgeInsets.zero),
      onPressed: () => switchPage(index),
      child: Container(
        height: size.width / 5,
        width: size.width / 2.1,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [color1, color2],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3)),
            ]),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (number != null)
                Positioned(top: 0, right: 0, child: Text("$number")),
              Row(
                children: [
                  Expanded(child: Image.asset(imagePath)),
                  Expanded(
                      child: Text(
                    text,
                    style: const TextStyle(fontSize: 12),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
