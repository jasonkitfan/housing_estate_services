import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/facility_booking_provider.dart';
import '../modify_library/event_calendar/flutter_clean_calendar.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool loading = true;

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<FacilityBookingProvider>(context, listen: false)
            .getAppointment());
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var events = Provider.of<FacilityBookingProvider>(context).events;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: loading ? 0 : 1,
      child: SafeArea(
        key: ValueKey(DateTime.now()),
        child: Calendar(
          startOnMonday: false,
          events: events,
          isExpandable: true,
          eventDoneColor: Colors.grey,
          selectedColor: Colors.green,
          todayColor: Colors.purple,
          eventColor: Colors.blue,
          isExpanded: true,
          dayOfWeekStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
        ),
      ),
    );
  }
}
