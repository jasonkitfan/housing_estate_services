import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/navigation_provider.dart';
import '../modify_library/event_calendar/clean_calendar_event.dart';
import '../model/facility_booking_model.dart';

class FacilityBookingProvider extends ChangeNotifier {
  DateTime date = DateTime.now();
  String facility = "";
  String? imagePath;
  String? price;
  String? currentVenuesNo;
  List<String> venuesList = ["1"];
  List selectedTime = [];
  Map? streamScheduleData;
  List<String> timeSection = List<String>.generate(
      24,
      (i) => DateFormat('HH:mm').format(
          DateTime.parse("2022-10-10 10:00:00.000Z")
              .add(Duration(minutes: i * 30))));

  /// ***********************Venues Handling***********************************/

  List<Map<String, dynamic>> availableVenues = [];

  void getAvailableVenues() {
    if (availableVenues.isNotEmpty) return;
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("available_venues")
        .snapshots()
        .listen((doc) {
      availableVenues.clear();
      for (var item in doc.docs) {
        availableVenues.add(item.data());
      }

      /// sort from a to z by the facility name
      availableVenues.sort((a, b) => a["name"].compareTo(b["name"]));
      notifyListeners();
    });
  }

  void initData() {
    facility = "";
    imagePath = null;
    price = "0";
    currentVenuesNo = "1";
    selectedTime.clear();
  }

  void changeVenuesNo(String index) {
    currentVenuesNo = index;
    selectedTime.clear();
    notifyListeners();
  }

  void insertFacility(
      String facility, String venues, String imagePath, String price) {
    if (facility == this.facility && int.parse(venues) == venuesList.length) {
      return;
    }
    this.facility = facility;
    this.imagePath = imagePath;
    this.price = price;
    venuesList =
        List<String>.generate(int.parse(venues), (i) => (i + 1).toString());
    currentVenuesNo = venuesList.first;
    date = DateTime.now();
    notifyListeners();
  }

  void insertDate(DateTime date) {
    this.date = date;
    selectedTime.clear();
    notifyListeners();
  }

  void updateVenues(String previousName, String name, String price,
      String venues, String imagePath, String animationPath) {
    var map = {
      "name": name,
      "price": price,
      "venues": venues,
      "image_path": imagePath,
      "animation": animationPath,
    };
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("available_venues")
        .where("name",
            isEqualTo: previousName) // use previous name to update the document
        .limit(1)
        .get()
        .then((doc) {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("facility_booking")
          .collection("available_venues")
          .doc(doc.docs.first.id)
          .update(map);
    });
    notifyListeners();
  }

  void addVenues(String name, String price, String venues, String imagePath,
      String animationPath) {
    var map = {
      "name": name,
      "price": price,
      "venues": venues,
      "image_path": imagePath,
      "animation": animationPath,
    };
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("available_venues")
        .doc()
        .set(map);
  }

  void deleteVenues(String name) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("available_venues")
        .where("name", isEqualTo: name)
        .limit(1)
        .get()
        .then((doc) {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("facility_booking")
          .collection("available_venues")
          .doc(doc.docs.first.id)
          .delete();
    });
  }

  /// ***********************Bar Chart Handling******************************/

  Map chartData = {};
  void get7DayData(String facility) {
    chartData[facility] = [];
    List d = List.generate(
        7,
        (index) => DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(Duration(days: index))));
    for (var date in d) {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("facility_booking")
          .collection("7_day_status")
          .where("name", isEqualTo: facility)
          .where("date", isEqualTo: date)
          .limit(1)
          .get()
          .then((doc) {
        return chartData[facility].add({
          "date": date,
          "day": DateFormat.E().format(DateTime.parse(date)),
          "number": doc.docs.first.data()["no_of_booking"]
        });
      }).catchError((e) {
        return chartData[facility].add({
          "date": date,
          "day": DateFormat.E().format(DateTime.parse(date)),
          "number": "0"
        });
      }).then((value) {
        notifyListeners();
      });
    }
  }

  /// ***********************Date Handling***********************************/

  /// add to booking cart
  void addToBookingList(bool add, String section) {
    Map<String, dynamic> map = {
      "owner": FirebaseAuth.instance.currentUser!.uid,
      "status": "processing",
      "last_update": DateTime.now()
    };

    if (add) {
      lockSchedule(map, section);
      checkCart(section);
    } else {
      releaseSchedule(section);
      removeFromCart(section);
    }
  }

  void lockSchedule(Map<String, dynamic> map, String section) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("schedule")
        .doc("${facility}_$currentVenuesNo")
        .collection(DateFormat("yyyy-MM-dd").format(date))
        .doc(section)
        .set(map, SetOptions(merge: true))
        .catchError((e) => e.toString());
  }

  void releaseSchedule(String section) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("schedule")
        .doc("${facility}_$currentVenuesNo")
        .collection(DateFormat("yyyy-MM-dd").format(date))
        .doc(section)
        .set({
      "owner": "",
      "status": "",
      "last_update": DateTime.now()
    }).catchError((e) => e.toString());
  }

  void checkCart(String section) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("cart")
        .doc("user_data")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .where(
          "date",
          isEqualTo: DateFormat("yyyy-MM-dd").format(date),
        )
        .where("name", isEqualTo: facility)
        .where("selected_venues", isEqualTo: currentVenuesNo)
        .where("status", isEqualTo: "processing")
        .limit(1)
        .get()
        .then((doc) {
      updateTimeSection(doc, section, true);
    }).catchError((e) {
      addToCart(section);
    });
  }

  void addToCart(String section) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("cart")
        .doc("user_data")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc()
        .set({
      "name": facility,
      "selected_venues": currentVenuesNo,
      "date": DateFormat("yyyy-MM-dd").format(date),
      "last_update": DateTime.now(),
      "time_section": [section],
      "status": "processing"
    });
  }

  void removeFromCart(String section) {
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("cart")
        .doc("user_data")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .where(
          "date",
          isEqualTo: DateFormat("yyyy-MM-dd").format(date),
        )
        .where("name", isEqualTo: facility)
        .where("selected_venues", isEqualTo: currentVenuesNo)
        .where("status", isEqualTo: "processing")
        .limit(1)
        .get()
        .then((doc) {
      updateTimeSection(doc, section, false);
    });
  }

  void updateTimeSection(var doc, String section, bool insert) {
    var data = doc.docs.first.data();
    List timeSection = data["time_section"];
    if (insert) {
      timeSection.add(section);
    } else {
      timeSection.removeWhere((element) => element == section);
    }
    timeSection.sort();
    data["time_section"] = timeSection;
    data["last_update"] = DateTime.now();
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("cart")
        .doc("user_data")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(doc.docs.first.id)
        .set(data)
        .catchError((e) => e.toString());
  }

  /// check if the time slot is booked or not
  Map bookingStatusMap = {};
  Stream streamBookingStatus() {
    bookingStatusMap = {};
    Stream stream = FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("schedule")
        .doc("${facility}_$currentVenuesNo")
        .collection(DateFormat("yyyy-MM-dd").format(date))
        .snapshots()
        .map((doc) {
      doc.docs.map((item) => bookingStatusMap[item.id] = item.data()).toList();
    });
    return stream;
  }

  // [1:booked by others, 2:can modified, 3:show color]
  List<bool> checkBookingStatus(String time) {
    /// disable the pass time
    if (DateTime.parse('${DateFormat("yyyy-MM-dd").format(date)} $time:00.000')
            .compareTo(DateTime.now()) <
        0) {
      return [false, false, false];
    }

    if (bookingStatusMap.containsKey(time)) {
      /// payment completed
      if (bookingStatusMap[time]["status"] == "completed") {
        return [true, false, false];
      }

      /// booking made by the same user but payment incomplete
      else if (bookingStatusMap[time]["owner"] ==
              FirebaseAuth.instance.currentUser!.uid &&
          bookingStatusMap[time]["status"] == "processing") {
        return [false, true, true];
      }

      /// someone release the schedule
      else if (bookingStatusMap[time]["owner"] == "") {
        return [false, true, false];
      }

      /// booking made by others
      else if (bookingStatusMap[time]["owner"] !=
          FirebaseAuth.instance.currentUser!.uid) {
        return [true, false, false];
      }
    }

    /// no one has booked before
    return [false, true, false];
  }

  /// ***********************Payment Handling***********************************/
  List<CartItem> cartList = [];

  void getDataFromCart() {
    cartList.clear();
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("cart")
        .doc("user_data")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .where("status", isEqualTo: "processing")
        .get()
        .then((doc) {
      var currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      for (var element in doc.docs) {
        var bookingDate = DateTime.parse(element.data()["date"]);
        if (bookingDate.compareTo(DateTime.parse(currentDate)) < 0) {
          continue; // stop showing the past date booking
        }
        if (element.data()["time_section"].isEmpty) {
          continue; // stop showing the cart item with empty time section
        }
        List tempList = availableVenues
            .where((item) => item.containsValue(element.data()["name"]))
            .toList(); // get the facility information
        List finalSection = element.data()["time_section"] as List;
        if (bookingDate.compareTo(DateTime.parse(currentDate)) == 0) {
          finalSection.removeWhere((section) =>
              DateTime.parse("$currentDate $section:00")
                  .compareTo(DateTime.now()) <
              0); // remove the past time section
        }
        if (finalSection.isEmpty) {
          continue;
        } // stop showing the empty section
        cartList.add(CartItem(
                name: element.data()["name"],
                selectedVenue: element.data()["selected_venues"],
                date: element.data()["date"],
                timeSection: finalSection,
                imagePath: tempList.first["image_path"],
                venues: tempList.first["venues"],
                price: tempList.first["price"],
                docId: element.id)
            // [
            // element.data()["name"],
            // element.data()["selected_venues"],
            // element.data()["date"],
            // finalSection, // time section
            // tempList.first["image_path"],
            // tempList.first["venues"],
            // tempList.first["price"],
            // element.id // document id
            // ]
            );
      }
    }).then((value) {
      notifyListeners();
    });
  }

  num totalAmount = 0; // for later receipt display
  num getTotalCharges() {
    num sum = 0;
    for (var item in cartList) {
      sum += item.timeSection.length * int.parse(item.price);
    }
    totalAmount = sum;
    return sum;
  }

  Future<void> initPaymentSheet(context) async {
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://asia-east2-housingservices-ad8cb.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': FirebaseAuth.instance.currentUser!.email,
            'amount': (getTotalCharges() * 100).toString(),
          });
      final jsonResponse = jsonDecode(response.body);
      // print(jsonResponse.toString());

      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Shape CW',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      /// payment succeed
      completePaymentAndClearCart();

      /// return to thank you screen
      Provider.of<NavigationProvider>(context, listen: false)
          .changeIndex(NavigationIndex.thankYouPayment.index, context: context);
    } catch (e) {
      /// payment failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Payment Incomplete',
          textAlign: TextAlign.center,
        )),
      );
    }
  }

  String orderReference = "";
  String transactionDate = "";
  void completePaymentAndClearCart() {
    orderReference = cartList.first.docId;
    transactionDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    update7DayData();
    for (var l in cartList) {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("facility_booking")
          .collection("cart")
          .doc("user_data")
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .where("name", isEqualTo: l.name)
          .where("selected_venues", isEqualTo: l.selectedVenue)
          .where("date", isEqualTo: l.date)
          .where("status", isEqualTo: "processing")
          .limit(1)
          .get()
          .then((doc) {
        FirebaseFirestore.instance
            .collection("shape_cw")
            .doc("facility_booking")
            .collection("cart")
            .doc("user_data")
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .doc(doc.docs.first.id)
            .update({
          "order_reference": orderReference,
          "status": "completed",
          "last_update": DateTime.now(),
          "time_section": l.timeSection
        });
        setScheduleToComplete(l.name, l.selectedVenue, l.date, l.timeSection);
      }).catchError((e) {
        e.toString();
      }).then((value) {
        if (cartList.isNotEmpty) {
          if (l == cartList.last) {
            cartList.clear();
            notifyListeners();
          }
        }
      });
    }
  }

  void update7DayData() {
    Map tempMap = {};

    /// group date section length of same facility with separated time section
    for (var l in cartList) {
      if (!tempMap.containsKey(l.name)) {
        tempMap[l.name] = {l.date: l.timeSection.length};
      } else if (!tempMap[l.name].containsKey(l.date)) {
        tempMap[l.name][l.date] = l.timeSection.length;
      } else {
        tempMap[l.name][l.date] += l.timeSection.length;
      }
    }

    tempMap.forEach((facility, nestMap) {
      nestMap.forEach((date, sectionLength) => FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("facility_booking")
          .collection("7_day_status")
          .where("date", isEqualTo: date)
          .where("name", isEqualTo: facility)
          .limit(1)
          .get()
          .then((doc) => FirebaseFirestore.instance // update document
                  .collection("shape_cw")
                  .doc("facility_booking")
                  .collection("7_day_status")
                  .doc(doc.docs.first.id)
                  .update({
                "no_of_booking":
                    "${int.parse(doc.docs.first.data()["no_of_booking"]) + sectionLength}",
                "last_update": DateTime.now()
              }))
          .catchError(
              (error) => FirebaseFirestore.instance // create new document
                      .collection("shape_cw")
                      .doc("facility_booking")
                      .collection("7_day_status")
                      .doc()
                      .set({
                    "date": date,
                    "name": facility,
                    "no_of_booking": sectionLength.toString(),
                    "last_update": DateTime.now()
                  })));
    });
  }

  // booking completed => disable selections from schedule
  void setScheduleToComplete(
      String facility, String selectedVenues, String date, List section) {
    for (var s in section) {
      FirebaseFirestore.instance
          .collection("shape_cw")
          .doc("facility_booking")
          .collection("schedule")
          .doc("${facility}_$selectedVenues")
          .collection(date)
          .doc(s)
          .update({"status": "completed"});
    }
  }

  /// check appointment
  List<PreAppointmentModel> allAppointment = [];
  void getAppointment() {
    if (availableVenues.isEmpty) {
      getAvailableVenues();
    }
    allAppointment.clear();
    FirebaseFirestore.instance
        .collection("shape_cw")
        .doc("facility_booking")
        .collection("cart")
        .doc("user_data")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .where("status", isEqualTo: "completed")
        .get()
        .then((doc) {
      for (var element in doc.docs) {
        var tempData = availableVenues
            .where((item) => item.values.contains(element.data()["name"]));
        allAppointment.add(PreAppointmentModel(
            facilityName: element.data()["name"],
            selectedVenue: element.data()["selected_venues"],
            date: element.data()["date"],
            selectedSection: element.data()["time_section"],
            animationPath: tempData.first["animation"]));
      }
    }).catchError((e) {
      e.toString();
    }).then((value) => setTimeLine());
  }

  List<FinalAppointmentModel> formatAllAppointment = [];
  void setTimeLine() {
    formatAllAppointment.clear();
    for (var item in allAppointment) {
      /// first check with only one section
      /// [10:30] => [10:30, 11:00]
      if (item.selectedSection.length == 1) {
        List l = [item.selectedSection[0], add30Min(item.selectedSection[0])];
        formatAllAppointment.add(FinalAppointmentModel(
            facilityName: item.facilityName,
            selectedVenues: item.selectedVenue,
            date: item.date,
            animationPath: item.animationPath,
            timeSection: l));
        continue; // stop to run another
      }

      /// second check
      /// [10:30,11:00] => [[10:30, 11:00], [11:00, 11:30]]
      int i = 0;
      List l2 = [];
      while (i < item.selectedSection.length) {
        l2.add([item.selectedSection[i], add30Min(item.selectedSection[i])]);
        i++;
      }

      /// third check
      /// [[10:30, 11:00], [11:00, 11:30]] => [10:30, 11:30]
      i = 1;
      List tempList = l2.first;
      while (i < l2.length) {
        if (l2[i][0] == tempList[1]) {
          tempList[1] = l2[i][1];
          if (i == l2.length - 1) {
            formatAllAppointment.add(FinalAppointmentModel(
                facilityName: item.facilityName,
                selectedVenues: item.selectedVenue,
                date: item.date,
                animationPath: item.animationPath,
                timeSection: tempList));
          }
        } else {
          formatAllAppointment.add(FinalAppointmentModel(
              facilityName: item.facilityName,
              selectedVenues: item.selectedVenue,
              date: item.date,
              animationPath: item.animationPath,
              timeSection: tempList));
          tempList = l2[i];
        }
        i++;
      }
    }
    showInCalender();
  }

  Map<DateTime, List<CleanCalendarEvent>> events = {};
  void showInCalender() {
    final newData =
        groupBy(formatAllAppointment, (FinalAppointmentModel fa) => fa.date);
    newData.forEach((key, value) {
      /// sort the order from earlier time follow by selected venue
      value.sort((a, b) => "${a.timeSection.first}_${a.selectedVenues}"
          .compareTo("${b.timeSection.first}_${b.selectedVenues}"));

      events[DateTime.parse(key)] = value
          .map(
            (FinalAppointmentModel fa) => CleanCalendarEvent(
              fa.facilityName, // title
              startTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  int.parse(fa.timeSection.first.split(":")[0]), // start hour
                  int.parse(fa.timeSection.first.split(":")[1])), // start min
              endTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  int.parse(fa.timeSection.last.split(":")[0]), // end hour
                  int.parse(fa.timeSection.last.split(":")[1])), // end min
              animation: fa.animationPath,
              color: Colors.green,
              description: "venue ${fa.selectedVenues}",
              isDone: DateTime.parse("${fa.date} ${fa.timeSection.last}:00")
                          .compareTo(DateTime.now()) <
                      0
                  ? true
                  : false,
            ), // subtitle
          )
          .toList();
    });
    notifyListeners();
  }

  String add30Min(dynamic hhMM) {
    return DateFormat("HH:mm").format(
        DateTime.parse("2022-10-10 $hhMM:00").add(const Duration(minutes: 30)));
  }
}
