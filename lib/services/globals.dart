import 'package:jitter/models/coffee.dart';
import 'package:jitter/models/report.dart';
import 'package:jitter/services/db.dart';

class Global {
  static final Map models = {
    Coffee: (data) => Coffee.fromMap(data),
    Report: (data) => Report.fromMap(data),
  };

  static final UserData<Report> reportRef =
      UserData<Report>(collection: "reports");
}
