import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widget/facility/facility_update.dart';
import '../../provider/facility_booking_provider.dart';
import '../../custom_widget/facility/facility_card.dart';

class FacilityModification extends StatefulWidget {
  const FacilityModification({Key? key}) : super(key: key);

  @override
  State<FacilityModification> createState() => _FacilityModificationState();
}

class _FacilityModificationState extends State<FacilityModification> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<FacilityBookingProvider>(context, listen: false)
            .getAvailableVenues());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider =
        Provider.of<FacilityBookingProvider>(context).availableVenues;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Facility Modification'),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.separated(
              itemBuilder: (context, index) => FacilityCard(
                name: provider[index]["name"],
                imagePath: provider[index]["image_path"],
                price: provider[index]["price"],
                venues: provider[index]["venues"],
                animationPath: provider[index]["animation"],
                icon: const Icon(Icons.mode_edit_outline_outlined),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: provider.length,
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const UpdateFacility(isUpdate: false)),
          highlightElevation: 30,
          child: const Icon(Icons.add),
        ));
  }
}
