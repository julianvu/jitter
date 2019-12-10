import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jitter/models/report.dart';
import 'package:jitter/services/firebase_auth_service.dart';
import 'package:jitter/services/globals.dart';
import 'package:jitter/widgets/ScaleRoute.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  FirebaseAuthService _authService = FirebaseAuthService();

  TabController _tabController;

  List data;
  List favorites;

  PageController _favoritesController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _favoritesController =
        PageController(initialPage: 1, viewportFraction: 0.6, keepPage: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Report report = Provider.of<Report>(context);
    favorites = [0];
    if (report != null) {
      favorites.addAll(report.favorites);
    }
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
      setState(() {
        favorites = [0];
        data = jsonResponse["results"];
//        favorites.addAll(data);
//        if (favorites.length > 1) {
//          _favoritesController.animateToPage(1,
//              duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
//        }
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _favoritesController.dispose();
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
                Container(
                  height: 350,
                  child: PageView.builder(
                    controller: _favoritesController,
                    itemCount: favorites.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimatedBuilder(
                        animation: _favoritesController,
                        builder: (BuildContext context, Widget widget) {
                          double value = 1.0;
                          if (_favoritesController.position.haveDimensions) {
                            value = _favoritesController.page - index;
                            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                          }
                          return Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 36.0, top: 36.0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 16.0,
                                    color: Colors.black54,
                                    offset: Offset(20, 10),
                                  ),
                                ],
                              ),
                              height: Curves.easeInOut.transform(value) * 300,
                              width: Curves.easeInOut.transform(value) * 200,
                              child: ClipRRect(
                                child: widget,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          );
                        },
                        child: index == 0
                            ? Stack(
                                children: [
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            ScaleRoute(
                                              page: Scaffold(
                                                backgroundColor: Colors.white,
                                                appBar: AppBar(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.plus,
                                          size: 64,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Stack(
                                children: [
                                  Positioned.fill(
                                    child: CachedNetworkImage(
                                      imageUrl: favorites[index]["imageURL"],
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          _addCoffee();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: data[index]["urls"]["regular"],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 32,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    data[index]["user"]["first_name"] +
                                        " " +
                                        data[index]["user"]["last_name"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
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
