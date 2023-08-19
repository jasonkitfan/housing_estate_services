import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int currentIndex = NavigationIndex.home.index;
  // int previousIndex = 0;

  void changeIndex(int index, {BuildContext? context}) {
    if (index == NavigationIndex.setting.index) {
      Scaffold.of(context!).openDrawer();
      return;
    }
    // previousIndex = currentIndex;
    currentIndex = index;
    notifyListeners();
  }

  // void returnIndex() {
  //   currentIndex = previousIndex;
  //   notifyListeners();
  // }
}

enum NavigationIndex {
  home,
  message,
  appointment,
  setting,
  smartHome,
  mailbox,
  facilityBooking,
  modifyFacility,
  thankYouPayment,
  locker,
  accessControl,
  bills,
  events,
  defects,
  moreNews,
  lostAndFound,
  neighbourInteractive,
  complaintAndReport,
  managementOfficeInquiry,
}
