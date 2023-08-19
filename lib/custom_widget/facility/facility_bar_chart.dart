import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/facility_booking_provider.dart';

class BuildChart extends StatefulWidget {
  const BuildChart({Key? key, required this.facility, required this.venues})
      : super(key: key);
  final String facility;
  final String venues;

  @override
  State<BuildChart> createState() => _BuildChartState();
}

class _BuildChartState extends State<BuildChart> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<FacilityBookingProvider>(context, listen: false)
            .get7DayData(widget.facility));
    super.initState();
  }

  List providerData = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var tempData = Provider.of<FacilityBookingProvider>(context).chartData;
    if (tempData.isNotEmpty) {
      providerData = tempData[widget.facility];
      providerData.sort((a, b) => a["date"].compareTo(b["date"]));
    }
    return Container(
      width: size.width / 2.1,
      padding: const EdgeInsets.all(5),
      child: providerData.length < 7
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SingleBar(
                  day: providerData[0]["day"],
                  val: int.parse(providerData[0]["number"]),
                  venues: widget.venues,
                ),
                const SizedBox(width: 10),
                SingleBar(
                  day: providerData[1]["day"],
                  val: int.parse(providerData[1]["number"]),
                  venues: widget.venues,
                ),
                const SizedBox(width: 10),
                SingleBar(
                  day: providerData[2]["day"],
                  val: int.parse(providerData[2]["number"]),
                  venues: widget.venues,
                ),
                const SizedBox(width: 10),
                SingleBar(
                  day: providerData[3]["day"],
                  val: int.parse(providerData[3]["number"]),
                  venues: widget.venues,
                ),
                const SizedBox(width: 10),
                SingleBar(
                  day: providerData[4]["day"],
                  val: int.parse(providerData[4]["number"]),
                  venues: widget.venues,
                ),
                const SizedBox(width: 10),
                SingleBar(
                  day: providerData[5]["day"],
                  val: int.parse(providerData[5]["number"]),
                  venues: widget.venues,
                ),
                const SizedBox(width: 10),
                SingleBar(
                  day: providerData[6]["day"],
                  val: int.parse(providerData[6]["number"]),
                  venues: widget.venues,
                ),
              ],
            ),
    );
  }
}

class SingleBar extends StatelessWidget {
  const SingleBar(
      {Key? key, required this.day, required this.val, required this.venues})
      : super(key: key);

  final String day;
  final int val;
  final String venues;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var timeSectionLength =
        Provider.of<FacilityBookingProvider>(context).timeSection.length;
    return SizedBox(
      width: size.width / 23,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30)),
                width: size.width / 50,
                height: size.width / 7,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color:
                            getColor(val, int.parse(venues), timeSectionLength),
                        borderRadius: BorderRadius.circular(30)),
                    width: size.width / 50 - 2,
                    height: val /
                        (int.parse(venues) * timeSectionLength) *
                        (size.width / 7)),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black)),
                width: size.width / 50,
                height: size.width / 7,
              ),
            ],
          ),
          Text(day, style: TextStyle(fontSize: size.width / 60))
        ],
      ),
    );
  }
}

MaterialColor getColor(int val, int totalVenues, int totalSection) {
  double value = val / (totalVenues * totalSection);
  if (value < 0.6) {
    return Colors.green;
  } else if (value < 0.8) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
