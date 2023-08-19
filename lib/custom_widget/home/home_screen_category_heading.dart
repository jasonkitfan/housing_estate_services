import 'package:flutter/material.dart';
import '../../provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class ItemHeading extends StatelessWidget {
  const ItemHeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var switchPage =
        Provider.of<NavigationProvider>(context, listen: false).changeIndex;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: [
          const Text(
            "Notices",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          TextButton(
              onPressed: () => switchPage(NavigationIndex.moreNews.index),
              child: const Text("More"))
        ],
      ),
    );
  }
}
