import 'package:flutter/material.dart';

class PreviewButton extends StatelessWidget {
  const PreviewButton(
      {Key? key,
      required this.buttonText,
      required this.icon,
      required this.color,
      required this.callback})
      : super(key: key);

  final IconData icon;
  final String buttonText;
  final Color color;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.grey.withOpacity(0.6))),
            onPressed: callback,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                const SizedBox(width: 10),
                Text(
                  buttonText,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }
}
