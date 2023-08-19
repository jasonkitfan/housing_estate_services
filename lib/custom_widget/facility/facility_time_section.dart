import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';

import '../../../provider/facility_booking_provider.dart';

class FacilityTimeSection extends StatefulWidget {
  const FacilityTimeSection({Key? key}) : super(key: key);

  @override
  State<FacilityTimeSection> createState() => _FacilityTimeSectionState();
}

class _FacilityTimeSectionState extends State<FacilityTimeSection> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 5;
    var provider = Provider.of<FacilityBookingProvider>(context);
    return Column(
      children: [
        StreamBuilder(
            key: ValueKey(DateTime.now()),
            stream: Provider.of<FacilityBookingProvider>(context)
                .streamBookingStatus(),
            builder: (context, snapshot) {
              return LayoutGrid(
                  columnGap: 5,
                  rowGap: 5,
                  rowSizes: List.generate(provider.timeSection.length ~/ 4,
                      (index) => (width / 2).px),
                  columnSizes: [width.px, width.px, width.px, width.px],
                  children: provider.timeSection
                      .map((e) => MyOutlinedButton(time: e))
                      .toList());
            }),
      ],
    );
  }
}

class MyOutlinedButton extends StatefulWidget {
  const MyOutlinedButton({Key? key, required this.time}) : super(key: key);
  final String time;

  @override
  State<MyOutlinedButton> createState() => _MyOutlinedButtonState();
}

class _MyOutlinedButtonState extends State<MyOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FacilityBookingProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool tap = provider.checkBookingStatus(widget.time)[2];
    return SizedBox(
        width: width / 5,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                foregroundColor: provider.checkBookingStatus(widget.time)[2]
                    ? Colors.white
                    : Colors.black,
                backgroundColor: provider.checkBookingStatus(widget.time)[2]
                    ? Colors.black
                    : provider.checkBookingStatus(widget.time)[1]
                        ? Colors.grey.withOpacity(0.2)
                        : null,
                side: BorderSide(
                    color: provider.checkBookingStatus(widget.time)[1]
                        ? Colors.black
                        : Colors.grey)),
            onPressed: provider.checkBookingStatus(widget.time)[0]
                ? null
                : provider.checkBookingStatus(widget.time)[1]
                    ? () {
                        setState(() {
                          tap = !tap;
                          provider.addToBookingList(tap, widget.time);
                        });
                      }
                    : null,
            child: Text(widget.time)));
  }
}
