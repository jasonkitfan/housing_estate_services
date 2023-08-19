class PreAppointmentModel {
  PreAppointmentModel({
    required this.facilityName,
    required this.selectedVenue,
    required this.date,
    required this.animationPath,
    required this.selectedSection,
  });

  String facilityName;
  String selectedVenue;
  String date;
  String animationPath;
  List selectedSection;
}

class FinalAppointmentModel {
  FinalAppointmentModel({
    required this.facilityName,
    required this.selectedVenues,
    required this.date,
    required this.animationPath,
    required this.timeSection,
  });

  String facilityName;
  String selectedVenues;
  String date;
  String animationPath;
  List timeSection;
}

class CartItem {
  CartItem({
    required this.name,
    required this.selectedVenue,
    required this.date,
    required this.timeSection,
    required this.imagePath,
    required this.venues,
    required this.price,
    required this.docId,
  });

  String name;
  String selectedVenue;
  String date;
  List timeSection;
  String imagePath;
  String venues;
  String price;
  String docId;
}
