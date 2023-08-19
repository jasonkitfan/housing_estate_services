import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:intl/intl.dart';

class DefectReportProvider extends ChangeNotifier {
  String defectLocation = "";
  String defectDescription = "";
  List defectImages = [];
  List downloadFirebaseUrl = [];
  List defectReport = [];
  String? userRole;
  List pendingIssue = [];
  List onProgressIssue = [];
  List maintenanceHistory = [];
  List completedCases = [];
  List<String> workerList = [];
  List<bool> workerChecked = [];

  // pie chart
  Map<String, int> pieChartData = {};
  late List<PieChartSectionData> sections = [];
  late List<String> indicator = [];
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  final List<String> dropDownList = <String>[
    'Air',
    'Fire',
    'Water',
    'Electrical',
    'Other'
  ];
  late String dropdownValue = dropDownList.first;

  void changeDropdownValue(String value) {
    dropdownValue = dropDownList[dropDownList.indexOf(value)];
    notifyListeners();
  }

  void getUserRole() {
    FirebaseFirestore.instance
        .collection("users_profile")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .limit(1)
        .get()
        .then((doc) {
      userRole = doc.docs.first["role"];
    }).then((value) {
      notifyListeners();
    });
  }

  void addGalleryImages(List<XFile> list) {
    for (var image in list) {
      defectImages.add(image.path);
    }
    notifyListeners();
  }

  void addCameraImage(String imagePath) {
    defectImages.add(imagePath);
    notifyListeners();
  }

  void removeImage(int index) {
    defectImages.removeAt(index);
    notifyListeners();
  }

  void setLocation(String location) {
    defectLocation = location;
  }

  void setDescription(String description) {
    defectDescription = description;
  }

  void submitReport() async {
    await uploadImage();
    createRecord();
  }

  void createRecord() {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .add({
      "created_at": DateTime.now(),
      "reported_by": FirebaseAuth.instance.currentUser!.email,
      "location": defectLocation,
      "description": defectDescription,
      "image_url": downloadFirebaseUrl,
      "status": "pending"
    }).then((_) {
      clearData();
    });
  }

  Future<void> uploadImage() async {
    for (int i = 0; i < defectImages.length; i++) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      Reference reference =
          FirebaseStorage.instance.ref().child('defect_images/$fileName');
      UploadTask uploadTask = reference.putFile(File(defectImages[i]));
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      downloadFirebaseUrl.add(downloadUrl);
    }
  }

  void clearData() {
    defectLocation = "";
    defectDescription = "";
    defectImages.clear();
    downloadFirebaseUrl.clear();
    notifyListeners();
  }

  // get report by user email for normal users
  void getDefectReports() {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .where("reported_by",
            isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen((docs) {
      defectReport.clear();
      for (var doc in docs.docs) {
        defectReport.add({
          "date": convertTimeFromFirebase(doc.data()["created_at"]),
          "imagePath": doc.data()["image_url"],
          "location": doc.data()["location"],
          "description": doc.data()["description"],
          "status": doc.data()["status"],
          "reporter": doc.data()["reported_by"],
          "id": doc.id,
          "worker": doc.data()["assigned_worker"],
          "remark": doc.data()["additional_message"],
          "reason": doc.data()["reason"]
        });
      }
      notifyListeners();
    });
  }

  // initialize admin function
  void adminDefectInfoInit() {
    getPendingIssue();
    getOnProgressIssue();
    getCompletedCases();
  }

  void getCompletedCases() {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .where("status", isEqualTo: "complete")
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen((docs) {
      completedCases.clear();
      for (var doc in docs.docs) {
        completedCases.add({
          "date": convertTimeFromFirebase(doc.data()["created_at"]),
          "imagePath": doc.data()["image_url"],
          "location": doc.data()["location"],
          "description": doc.data()["description"],
          "status": doc.data()["status"],
          "reporter": doc.data()["reported_by"],
          "id": doc.id
        });
      }
      notifyListeners();
    });
  }

  // get pending defects for admin users
  void getPendingIssue() {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .where("status", isEqualTo: "pending")
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen((docs) {
      pendingIssue.clear();
      for (var doc in docs.docs) {
        pendingIssue.add({
          "date": convertTimeFromFirebase(doc.data()["created_at"]),
          "imagePath": doc.data()["image_url"],
          "location": doc.data()["location"],
          "description": doc.data()["description"],
          "status": doc.data()["status"],
          "reporter": doc.data()["reported_by"],
          "id": doc.id
        });
      }
      notifyListeners();
    });
  }

  // get on progress report for admin users
  void getOnProgressIssue() {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .where("status", isEqualTo: "on progress")
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen((docs) {
      onProgressIssue.clear();
      for (var doc in docs.docs) {
        onProgressIssue.add({
          "date": convertTimeFromFirebase(doc.data()["created_at"]),
          "imagePath": doc.data()["image_url"],
          "location": doc.data()["location"],
          "description": doc.data()["description"],
          "status": doc.data()["status"],
          "reporter": doc.data()["reported_by"],
          "id": doc.id,
          "worker": doc.data()["assigned_worker"],
          "remark": doc.data()["additional_message"]
        });
      }
      notifyListeners();
    });
  }

  String convertTimeFromFirebase(time, {String format = "d MMM y"}) {
    var date = DateTime.parse(time.toDate().toString());
    String formattedCreatedAtString = DateFormat(format).format(date);
    return formattedCreatedAtString;
  }

  void rejectDefect(String reportId, String reason) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .doc(reportId)
        .update({"status": "rejected", "reason": reason});
  }

  void acceptDefect(String reportId, String message) {
    List<String> selectedWorkers = workerList
        .where((worker) => workerChecked[workerList.indexOf(worker)])
        .toList();

    // change the status
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .doc(reportId)
        .update({
      "status": "on progress",
      "assigned_worker": selectedWorkers,
      "additional_message": message,
      "maintenance_type": dropdownValue
    });

    // add history for tracing the maintenance record
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .doc(reportId)
        .collection("history")
        .add({
      "info": "defect report accepted.",
      "date": DateTime.now(),
      "accepted_by": FirebaseAuth.instance.currentUser!.email
    });
  }

  // get maintenance history
  void getMaintenanceHistory(String reportId) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .doc(reportId)
        .collection("history")
        .orderBy("date")
        .get()
        .then((docs) {
      maintenanceHistory.clear();
      for (var doc in docs.docs) {
        maintenanceHistory.add({
          "date": convertTimeFromFirebase(doc.data()["date"],
              format: "dd-MMM-yyyy HH:mm:ss"),
          "message": doc.data()["info"]
        });
      }
      notifyListeners();
    });
  }

  // update history
  void updateMaintenanceHistory(String action, String reportId,
      {String message = ""}) {
    if (action == "complete") {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("defect_reports")
          .collection("non_routine_tasks")
          .doc(reportId)
          .update({
        "status": "complete",
        "completed_at": DateTime.now(),
        "update_by": FirebaseAuth.instance.currentUser!.email
      });
    }

    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .doc(reportId)
        .collection("history")
        .add({
      "info": action == "complete" ? "complete" : message,
      "date": DateTime.now(),
      "update_by": FirebaseAuth.instance.currentUser!.email
    });
  }

  // get the worker list
  void getWorkerList() {
    FirebaseFirestore.instance
        .collection("users_profile")
        .where("role", isEqualTo: "engineering")
        .get()
        .then((workers) {
      workerList.clear();
      workerChecked.clear();
      for (var worker in workers.docs) {
        workerList.add(worker.data()["email"]);
        workerChecked.add(false);
      }
      notifyListeners();
    });
  }

  void checkWorker(int index) {
    workerChecked[index] = !workerChecked[index];
    notifyListeners();
  }

  // worker get on progress issue
  void getOnProgressIssueForWorker() {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .where("status", isEqualTo: "on progress")
        .where("assigned_worker",
            arrayContains: FirebaseAuth.instance.currentUser!.email)
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen((docs) {
      onProgressIssue.clear();
      for (var doc in docs.docs) {
        onProgressIssue.add({
          "date": convertTimeFromFirebase(doc.data()["created_at"]),
          "imagePath": doc.data()["image_url"],
          "location": doc.data()["location"],
          "description": doc.data()["description"],
          "status": doc.data()["status"],
          "reporter": doc.data()["reported_by"],
          "id": doc.id,
          "worker": doc.data()["assigned_worker"],
          "remark": doc.data()["additional_message"]
        });
      }
      notifyListeners();
    });
  }

  /// monthly pie chart
  void getMonthlyData() {
    var now = DateTime.now().toUtc().add(const Duration(hours: 8));
    var lastMonth = Timestamp.fromDate(DateTime.utc(now.year, now.month, 1));
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("non_routine_tasks")
        .where("created_at", isGreaterThan: lastMonth)
        .snapshots()
        .listen((docs) {
      pieChartData = {
        'Air': 0,
        'Fire': 0,
        'Water': 0,
        'Electrical': 0,
        'Other': 0
      };
      if (docs.docs.isNotEmpty) {
        for (var doc in docs.docs) {
          if (doc.data()["maintenance_type"] != null &&
              doc.data()["status"] != "pending" &&
              doc.data()["status"] != "rejected") {
            pieChartData[doc.data()["maintenance_type"]] =
                pieChartData[doc.data()["maintenance_type"]]! + 1;
          }
        }
        initPieChartSection();
        notifyListeners();
      }
    });
  }

  void initPieChartSection() {
    int totalSum = 0;
    pieChartData.forEach((key, value) {
      totalSum += value;
    });

    indicator.clear();

    sections = pieChartData.entries.map((entry) {
      int index = pieChartData.keys.toList().indexOf(entry.key);
      indicator.add(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble() / totalSum,
        color: colors[index],
        title:
            '${(entry.value.toDouble() / totalSum * 100).toStringAsFixed(1)}%', // show the value as a percentage
        radius: 30,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();
  }

  // routine task
  List dailyTask = [];

  void getDailyTask() {
    //shape_cw/defect_reports/daily_task/task_model
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("daily_task")
        .doc("task_model")
        .snapshots()
        .listen((docs) {
      dailyTask.clear();
      for (var doc in docs.data()?["model"]) {
        dailyTask.add(doc);
      }
      notifyListeners();
    });
  }

  void modifyDailyTask(int index, String title, String info) {
    dailyTask[index] = {"title": title, "detail": info};

    updateTask();
  }

  void removeDailyTask(int index) {
    dailyTask.removeAt(index);
    updateTask();
  }

  void updateTask() {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("defect_reports")
        .collection("daily_task")
        .doc("task_model")
        .set({"model": dailyTask});
  }

  void addTask(String taskTitle, String taskInfo) {
    dailyTask.add({"title": taskTitle, "detail": taskInfo});
    updateTask();
  }
}
