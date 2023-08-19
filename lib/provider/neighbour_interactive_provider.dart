import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NeighbourInteractiveProvider extends ChangeNotifier {
  List optionalImages = [];
  List optionalImageUrl = [];

  int loadRequestNumber = 7;

  bool isLoadingMore = false;
  List allRequest = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noDataMore = false;

  List history = [];

  void initData() {
    optionalImageUrl.clear();
    optionalImages.clear();

    allRequest.clear();
    lastDoc = null;
    noDataMore = false;

    notifyListeners();
    getData();
  }

  void loadMoreData() {
    isLoadingMore = true;
    Future.delayed(const Duration(seconds: 2), () => getData());
    notifyListeners();
  }

  void getData() {
    if (lastDoc == null) {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("help_and_gift")
          .collection("all_post")
          .orderBy("created_at", descending: true)
          .limit(loadRequestNumber)
          .get()
          .then((docs) {
        for (var doc in docs.docs) {
          allRequest.add(doc.data());
        }
        if (docs.size > 0) {
          lastDoc = docs.docs.last;
        }
        isLoadingMore = false;
        notifyListeners();
      });
    } else {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("help_and_gift")
          .collection("all_post")
          .orderBy("created_at", descending: true)
          .startAfter([lastDoc!["created_at"]])
          .limit(loadRequestNumber)
          .get()
          .then((docs) {
            for (var doc in docs.docs) {
              allRequest.add(doc.data());
            }

            lastDoc = docs.docs.last;
            isLoadingMore = false;
            notifyListeners();
          })
          .catchError((error) {
            noDataMore = true;
            notifyListeners();
          });
    }
  }

  void getHistoryData() async {
    history.clear();
    final currentUser = FirebaseAuth.instance.currentUser!.email;

    var collectionRef = FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post");

    var query1 =
        collectionRef.where("interested_people", arrayContains: currentUser);
    var query2 = collectionRef.where("user_email", isEqualTo: currentUser);

    var snapshots1 = await query1.get();
    var snapshots2 = await query2.get();

    var mergedSnapshots = [...snapshots1.docs, ...snapshots2.docs];

    mergedSnapshots.sort((a, b) {
      var timestampA = a["created_at"];
      var timestampB = b["created_at"];

      return timestampB.compareTo(timestampA);
    });

    for (var element in mergedSnapshots) {
      history.add(element);
    }
    notifyListeners();
  }

  void addGalleryImages(List<XFile> list) {
    for (var image in list) {
      optionalImages.add(image.path);
    }
    notifyListeners();
  }

  void removeImage(int index) {
    optionalImages.removeAt(index);
    notifyListeners();
  }

  Future<void> submitRequest(
      String title, String content, String formType, int? money) async {
    await uploadImage();

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post")
        .doc();

    var data = {
      "title": title,
      "content": content,
      "type": formType,
      "money": money ?? 0,
      "optional_image": optionalImageUrl,
      "user_email": FirebaseAuth.instance.currentUser!.email,
      "user_id": FirebaseAuth.instance.currentUser!.uid,
      "interested_people": [],
      "created_at": DateTime.now(),
      "id": documentReference.id
    };
    documentReference.set(data);
    initData();
  }

  Future<void> uploadImage() async {
    for (int i = 0; i < optionalImages.length; i++) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      Reference reference =
          FirebaseStorage.instance.ref().child('help_gift/$fileName');
      UploadTask uploadTask = reference.putFile(File(optionalImages[i]));
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      optionalImageUrl.add(downloadUrl);
    }
  }

  void applyHelpOrGift(String id, List people) {
    final currentUser = FirebaseAuth.instance.currentUser!.email;

    if (people.contains(currentUser)) {
      people.removeWhere((email) => email == currentUser);
    } else {
      people.add(currentUser);
    }

    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post")
        .doc(id)
        .update({"interested_people": people});

    initData();
    getHistoryData();
  }

  void addComment(String postId, String comment) {
    final collectionReference = FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("help_and_gift")
        .collection("all_post")
        .doc(postId)
        .collection("comments")
        .doc();

    final data = {
      "created_by": FirebaseAuth.instance.currentUser!.email,
      "created_at": DateTime.now(),
      "good": [],
      "bad": [],
      "comment": comment,
      "id": collectionReference.id
    };

    collectionReference.set(data);
  }
}
