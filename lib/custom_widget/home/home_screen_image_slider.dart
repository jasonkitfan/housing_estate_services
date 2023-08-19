import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../model/home_screen_image_slide_model.dart';

class MyImageSlider extends StatelessWidget {
  const MyImageSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.5,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ]),
      child: ImageSlideshow(
        isLoop: true,
        autoPlayInterval: 7000,
        indicatorColor: Colors.orange,
        children: imageSlideList,
      ),
    );
  }
}
