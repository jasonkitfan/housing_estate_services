import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../custom_widget/facility/facility_time_section.dart';
import '../../provider/facility_booking_provider.dart';

class DatePickingScreen extends StatefulWidget {
  const DatePickingScreen({Key? key, required this.function}) : super(key: key);

  final VoidCallback function;

  @override
  State<DatePickingScreen> createState() => _DatePickingScreenState();
}

class _DatePickingScreenState extends State<DatePickingScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FacilityBookingProvider>(context);
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          buildBackgroundImage(provider),
          buildBottomInfo(provider),
        ],
      ),
    );
  }

  Widget buildBottomInfo(FacilityBookingProvider provider) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            )),
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      provider.facility,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "\$${provider.price}/30Min",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                      child: Text(
                    "Date",
                    style: TextStyle(fontSize: 20),
                  )),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: buildDateButton()))
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Venue (${provider.venuesList.length})",
                      style: const TextStyle(fontSize: 20),
                    ),
                    buildVenueList()
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Time Section",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    const FacilityTimeSection(),
                    const SizedBox(height: 20),
                    buildButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackgroundImage(FacilityBookingProvider provider) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: provider.imagePath == null
                  ? const AssetImage("assets/images/no_image.png")
                      as ImageProvider
                  : NetworkImage(provider.imagePath!),
              fit: BoxFit.cover)),
    );
  }

  Widget buildButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(), backgroundColor: Colors.red),
          onPressed: () => widget.function(),
          child: const FittedBox(child: Text("continue to payment"))),
    );
  }

  SingleChildScrollView buildVenueList() {
    var provider = Provider.of<FacilityBookingProvider>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: provider.venuesList
            .map((e) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: EdgeInsets.zero,
                          foregroundColor: provider.currentVenuesNo == e
                              ? Colors.white
                              : Colors.black,
                          backgroundColor: provider.currentVenuesNo == e
                              ? Colors.black
                              : Colors.grey.withOpacity(0.5)),
                      onPressed: () => provider.changeVenuesNo(e),
                      child: Container(
                          width: 60,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Center(
                              child: Text(
                            e,
                          )))),
                ))
            .toList(),
      ),
    );
  }

  GestureDetector buildDateButton() {
    var provider = Provider.of<FacilityBookingProvider>(context);
    return GestureDetector(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: provider.date,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)));

          if (selectedDate == null) return;
          provider.insertDate(selectedDate);
        },
        child: Text(
          DateFormat.yMMMd().format(provider.date),
          style: const TextStyle(fontSize: 18, color: Colors.indigoAccent),
        ));
  }
}
