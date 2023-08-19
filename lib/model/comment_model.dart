import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  CommentModel({
    required this.sender,
    required this.createdAt,
    required this.comment,
    required this.thumbUp,
    required this.thumbDown,
    required this.commentId,
  });

  final String sender;
  final Timestamp createdAt;
  final String comment;
  final List thumbUp;
  final List thumbDown;
  final String commentId;
}
