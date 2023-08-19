import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {Key? key,
      required this.date,
      required this.location,
      required this.description,
      required this.status,
      this.imagePath = ""})
      : super(key: key);

  final String date;
  final String location;
  final String description;
  final String status;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date),
                  if (imagePath != "")
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    )
                ],
              )),
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 2,
              child:
                  Align(alignment: Alignment.centerRight, child: Text(status))),
        ],
      ),
    );
  }
}
