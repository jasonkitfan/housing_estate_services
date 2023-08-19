import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/facility_booking_provider.dart';
import '../../custom_widget/facility/facility_card.dart';

class SelectVenueScreen extends StatefulWidget {
  const SelectVenueScreen({Key? key, required this.function}) : super(key: key);

  final VoidCallback? function;

  @override
  State<SelectVenueScreen> createState() => _SelectVenueScreenState();
}

class _SelectVenueScreenState extends State<SelectVenueScreen> {
  bool loading = true;

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<FacilityBookingProvider>(context, listen: false)
            .getAvailableVenues());
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider =
        Provider.of<FacilityBookingProvider>(context).availableVenues;
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: loading ? 0 : 1,
            child: ListView.separated(
              itemBuilder: (context, index) => FacilityCard(
                name: provider[index]["name"],
                imagePath: provider[index]["image_path"],
                price: provider[index]["price"],
                venues: provider[index]["venues"],
                animationPath: provider[index]["animation"],
                function: widget.function,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: provider.length,
            ),
          )),
    );
  }
}
