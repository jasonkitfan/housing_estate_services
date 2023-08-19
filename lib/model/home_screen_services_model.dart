import 'package:flutter/material.dart';
import '../provider/navigation_provider.dart';

List<Map<String, dynamic>> servicesList = [
  {
    "image": "assets/images/services_list/smart_home.png",
    "text": "Smart Home",
    "color": const Color(0xff0392cf),
    "index": NavigationIndex.smartHome.index
  },
  {
    "image": "assets/images/services_list/mailbox.png",
    "text": "Mailbox",
    "color": const Color(0xff7bc043),
    "index": NavigationIndex.mailbox.index
  },
  {
    "image": "assets/images/services_list/calender.png",
    "text": "Facility Booking",
    "color": const Color(0xffee4035),
    "index": NavigationIndex.facilityBooking.index
  },
  {
    "image": "assets/images/services_list/locker.png",
    "text": "Locker",
    "color": const Color(0xfff37736),
    "index": NavigationIndex.locker.index
  },
  {
    "image": "assets/images/services_list/access_control.png",
    "text": "Access Control",
    "color": const Color(0xffbe9b7b),
    "index": NavigationIndex.accessControl.index
  },
  {
    "image": "assets/images/services_list/bill.png",
    "text": "Bills",
    "color": const Color(0xffffcc5c),
    "index": NavigationIndex.bills.index
  },
  {
    "image": "assets/images/services_list/firework.png",
    "text": "Events",
    "color": const Color(0xff5c65c0),
    "index": NavigationIndex.events.index
  },
  {
    "image": "assets/images/services_list/self_cabinet.png",
    "text": "Cabinet",
    "color": const Color(0xff536878),
    "index": NavigationIndex.defects.index
  },
];
