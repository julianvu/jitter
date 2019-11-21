import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jitter/models/report.dart';
import 'package:jitter/services/firebase_auth_service.dart';
import 'package:jitter/services/globals.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  FirebaseAuthService _authService = FirebaseAuthService();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    getJSONData();
  }

  Future<String> getAccessKey() async {
    RemoteConfig _remoteConfig = await RemoteConfig.instance;
    await _remoteConfig.fetch(expiration: Duration(seconds: 0));
    await _remoteConfig.activateFetched();
    return _remoteConfig.getString("unsplashAccessKey");
  }

  void getJSONData() async {
    String url = "https://api.unsplash.com/search/photos?page=1&query=coffee";
    String key = "&client_id=${await getAccessKey()}";
    // Await HTTP GET response, then decode JSON-formatted response
    http.Response response = await http.get(url + key);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      int itemCount = jsonResponse["total"];
      print("Number of images about coffee: $itemCount.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => OptionsBottomSheet(),
        backgroundColor: Colors.transparent);
  }

  Future<void> _addCoffee() {
    return Global.reportRef.upsert({
      "totalCoffees": FieldValue.increment(1),
      "lastActivity": DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);

    return Scaffold(
      bottomNavigationBar: Card(
        margin: EdgeInsets.only(bottom: 0.0, left: 4.0, right: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        elevation: 10.0,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.coffee),
                  onPressed: () {
                    setState(() {
                      _tabController.index = 0;
                    });
                  },
                  color: _tabController.index == 0
                      ? Theme.of(context).splashColor
                      : Colors.black,
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.chartBar),
                  onPressed: () {
                    setState(() {
                      _tabController.index = 1;
                    });
                  },
                  color: _tabController.index == 1
                      ? Theme.of(context).splashColor
                      : Colors.black,
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
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                report != null
                    ? Text(
                        "${report.totalCoffees.toString()}",
                        style: TextStyle(fontSize: 128.0),
                      )
                    : Text("No coffees"),
                RaisedButton(
                  onPressed: () {
                    _addCoffee();
                  },
                  child: Text("Add Coffee"),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
          ),
        ],
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
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
          ),
        ],
      ),
    );
    ;
  }
}
