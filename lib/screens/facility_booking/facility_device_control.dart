import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FacilityDeviceControl extends StatefulWidget {
  const FacilityDeviceControl({Key? key}) : super(key: key);

  @override
  State<FacilityDeviceControl> createState() => _FacilityDeviceControlState();
}

class _FacilityDeviceControlState extends State<FacilityDeviceControl> {
  final databaseReference = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _streamSubscription;

  bool open = false;

  void openDoor() {
    databaseReference.child("facility/testing_room/door").set("open");
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription = databaseReference
        .child("facility/testing_room/door")
        .onValue
        .listen((event) {
      String doorStatus = event.snapshot.value as String;
      if (doorStatus == "close") {
        setState(() {
          open = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Control"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Door",
                style: TextStyle(fontSize: 20),
              ),
              Switch(
                // This bool value toggles the switch.
                value: open,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.
                  if (value == false) {
                    return;
                  }
                  setState(() {
                    openDoor();
                    open = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
