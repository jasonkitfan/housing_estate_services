import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/facility_booking_provider.dart';

class UpdateFacility extends StatefulWidget {
  const UpdateFacility(
      {Key? key,
      this.name = "",
      this.price = "",
      this.venues = "",
      this.imagePath = "",
      this.animationPath = "",
      required this.isUpdate})
      : super(key: key);

  final String name;
  final String price;
  final String venues;
  final String imagePath;
  final String animationPath;
  final bool isUpdate;

  @override
  State<UpdateFacility> createState() => _UpdateFacility();
}

class _UpdateFacility extends State<UpdateFacility> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController venuesController = TextEditingController();
  final TextEditingController animationPathController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.name;
    imagePathController.text = widget.imagePath;
    priceController.text = widget.price;
    venuesController.text = widget.venues;
    animationPathController.text = widget.animationPath;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    imagePathController.dispose();
    venuesController.dispose();
    animationPathController.dispose();
    super.dispose();
  }

  Future<void> popDialog(BuildContext context) {
    var delete = Provider.of<FacilityBookingProvider>(context, listen: false)
        .deleteVenues;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content:
              Text("Do you really want to delete the facility: ${widget.name}"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                delete(widget.name);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FacilityBookingProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: !widget.isUpdate
                  ? const Center(
                      child: Text("Add New Facility"),
                    )
                  : Stack(
                      children: [
                        Center(
                            child: Text("Modifying Facility: ${widget.name}")),
                        Positioned(
                            right: 0,
                            child: GestureDetector(
                                onTap: () => popDialog(context),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )))
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "name",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 3))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: imagePathController,
              decoration: const InputDecoration(
                  labelText: "image_path",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 3))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: animationPathController,
              decoration: const InputDecoration(
                  labelText: "animation_path",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 3))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "price",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 3))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: venuesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "venues",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 3))),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    widget.isUpdate
                        ? provider.updateVenues(
                            widget.name,
                            nameController.text,
                            priceController.text,
                            venuesController.text,
                            imagePathController.text,
                            animationPathController.text,
                          )
                        : provider.addVenues(
                            nameController.text,
                            priceController.text,
                            venuesController.text,
                            imagePathController.text,
                            animationPathController.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      surfaceTintColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                )),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom))
          ],
        ),
      ),
    );
  }
}
