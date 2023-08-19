import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/neighbour_interactive_provider.dart';

class AddPostViewPostButton extends StatefulWidget {
  const AddPostViewPostButton(
      {Key? key,
      required this.icon,
      required this.buttonText,
      required this.color,
      required this.widget})
      : super(key: key);

  final IconData icon;
  final String buttonText;
  final Color color;
  final Widget widget;

  @override
  State<AddPostViewPostButton> createState() => _AddPostViewPostButtonState();
}

class _AddPostViewPostButtonState extends State<AddPostViewPostButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        // print("${widget.buttonText} is pressed");
        Provider.of<NeighbourInteractiveProvider>(context, listen: false)
            .initData();
        showDialog(
            useSafeArea: false,
            context: context,
            builder: (context) => widget.widget);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 50,
            ),
            Text(
              widget.buttonText,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    ));
  }
}
