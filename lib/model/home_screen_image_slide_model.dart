import 'package:flutter/material.dart';

List<Widget> imageSlideList = [
  GestureDetector(
    onTap: () => print("pic 0 is tapped"),
    child: Image.asset(
      "assets/images/image_slide/img.png",
      fit: BoxFit.fill,
    ),
  ),
  GestureDetector(
    onTap: () => print("pic 1 is tapped"),
    child: Image.asset(
      "assets/images/image_slide/img_1.png",
      fit: BoxFit.fill,
    ),
  ),
  GestureDetector(
    onTap: () => print("pic 2 is tapped"),
    child: Image.asset(
      "assets/images/image_slide/img_2.png",
      fit: BoxFit.fill,
    ),
  ),
  GestureDetector(
    onTap: () => print("pic 3 is tapped"),
    child: Image.asset(
      "assets/images/image_slide/img_3.png",
      fit: BoxFit.fill,
    ),
  ),
  GestureDetector(
    onTap: () => print("pic 4 is tapped"),
    child: Image.asset(
      "assets/images/image_slide/img_4.png",
      fit: BoxFit.fill,
    ),
  ),
];
