import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  const CommentCard(
      {Key? key,
      required this.sender,
      required this.sendDate,
      required this.comment,
      required this.good,
      required this.bad,
      required this.commentId,
      required this.postId})
      : super(key: key);

  final String sender;
  final Timestamp sendDate;
  final String comment;
  final List good;
  final List bad;
  final String postId;
  final String commentId;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final currentUser = FirebaseAuth.instance.currentUser!.email;

  void checkLike(String type) {
    if (type == "good") {
      if (widget.good.contains(currentUser)) {
        widget.good.removeWhere((email) => email == currentUser);
      } else {
        widget.good.add(currentUser);
      }
      // update record
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("help_and_gift")
          .collection("all_post")
          .doc(widget.postId)
          .collection("comments")
          .doc(widget.commentId)
          .update({"good": widget.good});
    } else {
      if (widget.bad.contains(currentUser)) {
        widget.bad.removeWhere((email) => email == currentUser);
      } else {
        widget.bad.add(currentUser);
      }
      // update record
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("help_and_gift")
          .collection("all_post")
          .doc(widget.postId)
          .collection("comments")
          .doc(widget.commentId)
          .update({"bad": widget.bad});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(widget.sender[0])),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.sender.split("@")[0]),
                    const SizedBox(height: 1),
                    Text(
                      DateFormat("yyyy-MM-dd   HH:mm:ss")
                          .format(widget.sendDate.toDate()),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            const Divider(thickness: 1),
            SizedBox(
                width: double.infinity,
                child: Text(
                  widget.comment,
                  textAlign: TextAlign.justify,
                )),
            const SizedBox(height: 5),
            const Divider(thickness: 1),
            Row(
              children: [
                const SizedBox(width: 10),
                Text("${widget.good.length}"),
                const SizedBox(width: 10),
                GestureDetector(
                    onTap: () => checkLike("good"),
                    child: widget.good.contains(currentUser)
                        ? const Icon(Icons.thumb_up_alt)
                        : const Icon(Icons.thumb_up_alt_outlined)),
                const SizedBox(width: 10),
                Text("${widget.bad.length}"),
                const SizedBox(width: 10),
                GestureDetector(
                    onTap: () => checkLike("bad"),
                    child: widget.bad.contains(currentUser)
                        ? const Icon(Icons.thumb_down_alt)
                        : const Icon(Icons.thumb_down_alt_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }
}
