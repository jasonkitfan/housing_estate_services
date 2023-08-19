import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/neighbour_interactive_provider.dart';
import '../../model/comment_model.dart';
import 'neighbour_interactive_components/comment_card.dart';
import 'neighbour_interactive_components/request_info_card.dart';

class PostDetailView extends StatefulWidget {
  const PostDetailView(
      {Key? key,
      required this.posterEmail,
      required this.timestamp,
      required this.title,
      required this.content,
      required this.postId,
      required this.interestedPeopleList,
      required this.imageUrlList,
      this.assignedPerson})
      : super(key: key);

  final String title;
  final String content;
  final String posterEmail;
  final Timestamp timestamp;
  final List imageUrlList;
  final List interestedPeopleList;
  final String postId;
  final String? assignedPerson;

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  final _textEditingController = TextEditingController();
  StreamSubscription<QuerySnapshot>? commentStream;
  List<CommentModel> commentList = [];

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void getComment(String firstDocId) {
    commentStream = FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post")
        .doc(firstDocId)
        .collection("comments")
        .orderBy("created_at")
        .snapshots()
        .listen((docs) {
      commentList.clear();
      for (var doc in docs.docs) {
        commentList.add(
          CommentModel(
            sender: doc.data()["created_by"],
            createdAt: doc.data()["created_at"],
            comment: doc.data()["comment"],
            thumbUp: doc.data()["good"],
            thumbDown: doc.data()["bad"],
            commentId: doc.id,
          ),
        );
        setState(() {});
      }
    });
  }

  void cancelCommentStream() {
    commentStream?.cancel();
  }

  @override
  void initState() {
    getComment(widget.postId);
    super.initState();
  }

  @override
  void dispose() {
    cancelCommentStream();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _dismissKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      RequestInfoCard(
                        posterEmail: widget.posterEmail,
                        timestamp: widget.timestamp,
                        content: widget.content,
                        imageUrlList: widget.imageUrlList,
                        interestedPeopleList: widget.interestedPeopleList,
                        postId: widget.postId,
                        title: widget.title,
                        assignedNeighbour: widget.assignedPerson,
                      ),
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: commentList.length,
                          separatorBuilder: (c, i) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) => CommentCard(
                                sender: commentList[index].sender,
                                sendDate: commentList[index].createdAt,
                                comment: commentList[index].comment,
                                good: commentList[index].thumbUp,
                                bad: commentList[index].thumbDown,
                                commentId: commentList[index].commentId,
                                postId: widget.postId,
                              ))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: 60,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              isCollapsed: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Enter text',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Provider.of<NeighbourInteractiveProvider>(context,
                                    listen: false)
                                .addComment(
                                    widget.postId, _textEditingController.text);
                            FocusScope.of(context).unfocus();
                            _textEditingController.clear();
                          },
                          child: const Icon(Icons.send))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
