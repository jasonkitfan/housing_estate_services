import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/home_screen_services_model.dart';
import '../../provider/facility_booking_provider.dart';
import 'facility_booking_date_picking.dart';
import 'facility_booking_payment.dart';
import 'facility_booking_select_venue.dart';

class FacilityBookingScreen extends StatefulWidget {
  const FacilityBookingScreen({Key? key}) : super(key: key);

  @override
  State<FacilityBookingScreen> createState() => _FacilityBookingScreenState();
}

class _FacilityBookingScreenState extends State<FacilityBookingScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  List<Widget>? bookingWidget;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<FacilityBookingProvider>(context, listen: false).initData();
    });
    bookingWidget = [
      SelectVenueScreen(function: switchDatePicking),
      DatePickingScreen(function: switchPayment),
      BookingPaymentScreen(function: switchDatePicking),
    ];
    tabController = TabController(length: bookingWidget!.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  void switchDatePicking() {
    tabController!.animateTo(1);
  }

  void switchPayment() {
    tabController!.animateTo(2);
  }

  void changeIndex(int index, String? path) {
    if (index == 1 && path == null) {
      tabController!.animateTo(0);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Please selected a facility first!",
        textAlign: TextAlign.center,
      )));
    } else {
      tabController!.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var imagePath = Provider.of<FacilityBookingProvider>(context).imagePath;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Facility Booking"),
          backgroundColor: servicesList[2]["color"],
          bottom: TabBar(
            controller: tabController,
            onTap: (index) {
              changeIndex(index, imagePath);
            },
            tabs: const [
              Tab(icon: Text("Venue")),
              Tab(icon: Text("Date")),
              Tab(icon: Text("Payment")),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: bookingWidget!,
        ),
      ),
    );
  }
}
