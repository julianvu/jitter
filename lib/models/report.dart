import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String uid;
  int totalCoffees;
  DateTime lastActivity;

  Report({this.uid, this.totalCoffees, this.lastActivity});

  factory Report.fromMap(Map data) {
    return Report(
      uid: data["uid"] ?? "",
      totalCoffees: data["totalCoffees"] ?? 0,
      lastActivity:
          (data["lastActivity"] as Timestamp).toDate() ?? DateTime.now(),
    );
  }
}
