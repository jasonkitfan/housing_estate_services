import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/neighbour_interactive_provider.dart';

class RequestInfoCard extends StatefulWidget {
  const RequestInfoCard({
    super.key,
    required this.posterEmail,
    required this.timestamp,
    required this.content,
    required this.imageUrlList,
    required this.interestedPeopleList,
    required this.postId,
    required this.title,
    this.assignedNeighbour,
  });

  final String title;
  final String posterEmail;
  final Timestamp timestamp;
  final String content;
  final List imageUrlList;
  final List interestedPeopleList;
  final String postId;
  final String? assignedNeighbour;

  @override
  State<RequestInfoCard> createState() => _RequestInfoCardState();
}

class _RequestInfoCardState extends State<RequestInfoCard> {
  List volunteerList = [];
  StreamSubscription<DocumentSnapshot>? streamVolunteer;
  String? assignedNeighbour;

  void assignNeighbour(String neighbour) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post")
        .doc(widget.postId)
        .update({
      "assigned_neighbour": neighbour,
      "type": "close",
    });

    final data = {
      "postId": widget.postId,
      "poster": widget.posterEmail,
      "postTitle": widget.title,
      "selected_person": neighbour,
      "created_at": DateTime.now()
    };

    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("message")
        .collection("all_message")
        .doc()
        .set(data);
  }

  void getInterestedPeople() {
    streamVolunteer = FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post")
        .doc(widget.postId)
        .snapshots()
        .listen((doc) {
      volunteerList = doc.data()?["interested_people"];
      assignedNeighbour = doc.data()?["assigned_neighbour"];
      setState(() {});
    });
  }

  void cancelStream() {
    streamVolunteer?.cancel();
  }

  void popConfirmDialog(String neighbour) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Confirmation"),
              content: Text("Assign the request to ${neighbour.split("@")[0]}"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, "Cancel"),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    assignNeighbour(neighbour);
                    Navigator.pop(context, "OK");
                    Navigator.of(context).pop();
                    Provider.of<NeighbourInteractiveProvider>(context,
                            listen: false)
                        .initData();
                  },
                  child: const Text("OK"),
                ),
              ],
            ));
  }

  @override
  void initState() {
    getInterestedPeople();
    super.initState();
  }

  @override
  void dispose() {
    cancelStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(widget.posterEmail[0]),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.posterEmail.split("@")[0]),
                    const SizedBox(height: 1),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(widget.timestamp.toDate()),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 1),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.content),
                  if (widget.imageUrlList.isNotEmpty)
                    ...List.generate(
                        widget.imageUrlList.length,
                        (index) => Column(
                              children: [
                                const SizedBox(height: 10),
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    widget.imageUrlList[index],
                                  ),
                                ),
                              ],
                            )),
                  const SizedBox(height: 10),
                  if (widget.assignedNeighbour != null)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "matched with ${widget.assignedNeighbour?.split("@")[0]}",
                        textAlign: TextAlign.right,
                      ),
                    ),

                  // show apply or cancel button for other users
                  if (widget.posterEmail !=
                          FirebaseAuth.instance.currentUser!.email &&
                      widget.assignedNeighbour !=
                          FirebaseAuth.instance.currentUser!.email)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.interestedPeopleList
                                      .contains(FirebaseAuth
                                          .instance.currentUser!.email)
                                  ? Colors.red
                                  : Colors.blue),
                          onPressed: () {
                            Provider.of<NeighbourInteractiveProvider>(context,
                                    listen: false)
                                .applyHelpOrGift(
                                    widget.postId, widget.interestedPeopleList);
                            Navigator.of(context).pop();
                          },
                          child: Text(widget.interestedPeopleList.contains(
                                  FirebaseAuth.instance.currentUser!.email)
                              ? "Cancel"
                              : "Apply")),
                    ),
                  if (widget.posterEmail ==
                          FirebaseAuth.instance.currentUser!.email &&
                      volunteerList.isNotEmpty &&
                      assignedNeighbour == null)
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 3,
                            color: Colors.grey,
                          ),
                          const Text(
                            "Interested People",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          ...List.generate(
                              volunteerList.length,
                              (index) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(volunteerList[index].split("@")[0]),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () => popConfirmDialog(
                                              volunteerList[index]),
                                          child: const Text("Select"))
                                    ],
                                  ))
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
