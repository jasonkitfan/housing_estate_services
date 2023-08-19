import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/facility_booking_provider.dart';
import 'facility_update.dart';
import 'facility_bar_chart.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.venues,
    required this.animationPath,
    this.function,
    this.icon,
  }) : super(key: key);

  final String name;
  final String imagePath;
  final String price;
  final String venues;
  final String animationPath;
  final Icon? icon;
  final VoidCallback? function;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<FacilityBookingProvider>(context);
    return GestureDetector(
      onTap: () {
        provider.insertFacility(name, venues, imagePath, price);
        if (icon == null) {
          function!();
          // DefaultTabController.of(context)!.animateTo(1);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: icon == null
                ? provider.facility == name
                    ? const Color(0xff005b96).withOpacity(0.45)
                    : Colors.white.withOpacity(0.7)
                : Colors.white.withOpacity(0.7),
            border: Border.all(color: Colors.green),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Row(
          children: [
            SizedBox(
                width: size.width / 3,
                child: Stack(
                  children: [
                    Image.network(
                      imagePath,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset("assets/images/no_image.png");
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Stack(
              children: [
                Container(
                  width: size.width - size.width / 3 - 42,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      BuildChart(facility: name, venues: venues),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("\$$price/30Min"),
                          Text("venues: $venues")
                        ],
                      )
                    ],
                  ),
                ),
                if (icon != null)
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => UpdateFacility(
                                  name: name,
                                  price: price,
                                  venues: venues,
                                  imagePath: imagePath,
                                  animationPath: animationPath,
                                  isUpdate: true,
                                ));
                      },
                      child: Container(
                          color: Colors.grey.withOpacity(0.4),
                          child: const Icon(Icons.mode_edit_outline_outlined)),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
