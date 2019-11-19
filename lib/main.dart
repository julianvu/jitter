import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitter/models/report.dart';
import 'package:jitter/pages/home_page.dart';
import 'package:jitter/pages/login_page.dart';
import 'package:jitter/pages/signup_page.dart';
import 'package:jitter/services/firebase_auth_service.dart';
import 'package:jitter/services/globals.dart';
import 'package:provider/provider.dart';

void main() async {
  final FirebaseUser _user = await FirebaseAuthService().getUser;
  final String initialRoute = _user == null ? "/" : "/home";
  runApp(MyApp(
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuthService().user,
        ),
        StreamProvider<Report>.value(
          value: Global.reportRef.documentStream,
        ),
      ],
      child: MaterialApp(
        title: 'Jitter',
        theme: ThemeData(
          /*
          Colors
           */
          primaryColor: Color(0xFFa7efe9),
          accentColor: Color(0xFF7fdfd4),
          backgroundColor: Color(0xFFfbe1b6),
          scaffoldBackgroundColor: Color(0xFFfbe1b6),
          splashColor: Color(0xFFfbac91),
          bottomAppBarColor: Color(0xFFa7efe9),

          /*
          Typography
           */
          fontFamily: "Varela Round",
          textTheme: TextTheme(
            headline: TextStyle(
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
            ),
            title: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.italic,
            ),
            body1: TextStyle(
              fontSize: 16.0,
            ),
            body2: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        routes: {
          "/": (context) => LoginPage(),
          "/home": (context) => HomePage(),
          "/signup": (context) => SignUpPage(),
        },
        initialRoute: initialRoute,
      ),
    );
  }
}
