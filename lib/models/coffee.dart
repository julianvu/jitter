import 'package:cloud_firestore/cloud_firestore.dart';

class Coffee {
  int caffeineInMg;
  String size;
  DateTime timeConsumed;
  String uid;

  Coffee({this.uid, this.caffeineInMg, this.size, this.timeConsumed});

  Coffee.fromMap(Map data) {
    this.uid = data["uid"];
    this.caffeineInMg = data["caffeineInMg"];
    this.size = data["size"];
    this.timeConsumed = (data["timeConsumed"] as Timestamp).toDate();
  }
}
