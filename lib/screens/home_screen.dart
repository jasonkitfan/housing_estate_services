import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../custom_widget/home/home_screen_category_heading.dart';
import '../custom_widget/home/home_screen_extra_services.dart';
import '../custom_widget/home/home_screen_service_item.dart';
import '../custom_widget/home/home_screen_image_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            if (defaultTargetPlatform == TargetPlatform.iOS)
              const SizedBox(height: 35),
            const ItemHeading(),
            const MyImageSlider(),
            const SizedBox(height: 10),
            const ServiceItems(),
            const SizedBox(height: 10),
            const ExtraServices(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
