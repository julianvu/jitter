import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jitter/pages/login_page.dart';
import 'package:jitter/services/firebase_auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuthService _authService = FirebaseAuthService();

  void _showModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => OptionsBottomSheet(),
        backgroundColor: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.red),
      child: Scaffold(
        bottomNavigationBar: Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.coffee),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.chartBar),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.cog),
                    onPressed: () {
                      _showModalBottomSheet();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class OptionsBottomSheet extends StatelessWidget {
  FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: <Widget>[
          Center(
            child: Icon(FontAwesomeIcons.gripLines),
          ),
          Material(
            color: Theme.of(context).backgroundColor,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.signOutAlt),
              title: Text("Log Out"),
              onTap: () async {
                await _authService.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    ;
  }
}
