import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel(
      {required this.postId,
      required this.poster,
      required this.postTitle,
      required this.selectedPerson,
      required this.createdAt});

  final String poster;
  final String postId;
  final String postTitle;
  final String selectedPerson;
  final Timestamp createdAt;
}
