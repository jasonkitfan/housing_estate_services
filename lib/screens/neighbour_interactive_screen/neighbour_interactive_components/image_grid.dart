import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/neighbour_interactive_provider.dart';

class HelpGiftImageGrid extends StatelessWidget {
  const HelpGiftImageGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageList =
        Provider.of<NeighbourInteractiveProvider>(context).optionalImages;

    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: imageList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemBuilder: (BuildContext context, int index) => Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    File(imageList[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    right: 5,
                    top: 5,
                    child: GestureDetector(
                      onTap: () => Provider.of<NeighbourInteractiveProvider>(
                              context,
                              listen: false)
                          .removeImage(index),
                      child: const Icon(
                        Icons.highlight_remove_outlined,
                        size: 15,
                      ),
                    ))
              ],
            ));
  }
}
