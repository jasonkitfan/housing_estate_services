import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/neighbour_interactive_screen/post_detail_view.dart';
import '../model/message_model.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  StreamSubscription? streamSubscription;
  List<MessageModel> messageList = [];

  Future<dynamic> getMoreInfo(String id) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post")
        .doc(id)
        .get();
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data();
      return data;
    } else {
      return null;
    }
  }

  void openDetailView(info) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetailView(
                posterEmail: info["user_email"],
                timestamp: info["created_at"],
                content: info["content"],
                imageUrlList: info["optional_image"],
                interestedPeopleList: info["interested_people"],
                postId: info["id"],
                title: info["title"],
                assignedPerson: info["assigned_neighbour"],
              )),
    );
  }

  @override
  void initState() {
    streamSubscription = FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("message")
        .collection("all_message")
        .where("selected_person",
            isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .listen((doc) {
      messageList.clear();
      for (var element in doc.docs) {
        messageList.add(
          MessageModel(
            postId: element.data()["postId"],
            poster: element.data()["poster"],
            postTitle: element.data()["postTitle"],
            selectedPerson: element.data()["selected_person"],
            createdAt: element.data()["created_at"],
          ),
        );
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: messageList.length,
          itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your match with \"${messageList[index].poster.split("@")[0]}\" on \"${messageList[index].postTitle}\" is accepted",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final info =
                                  await getMoreInfo(messageList[index].postId);
                              if (info == null) {
                                return;
                              }
                              openDetailView(info);
                            },
                            child: const Text(
                              "Information",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                          ),
                          const Spacer(),
                          Text(
                              "  ${DateFormat('yyyy-MM-dd  HH:mm:ss').format(messageList[index].createdAt.toDate())}")
                        ],
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
