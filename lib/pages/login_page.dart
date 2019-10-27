import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitter/pages/signup_page.dart';
import 'package:jitter/pages/splash_page.dart';
import 'package:jitter/services/firebase_auth_service.dart';
import 'package:jitter/widgets/login_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuthService authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Hero(
                      tag: "jitter-logo-startup",
                      child: Image.asset(
                        "assets/jitter-logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: MaterialButton(
                      onPressed: () async {
                        FirebaseUser user = Provider.of<FirebaseUser>(context);
                        if (user == null) {
                          FirebaseUser tempUser =
                              await authService.signInWithGoogle();
                          if (tempUser != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Mock(),
                              ),
                            );
                          }
                        } else {
                          print(user);
                        }
                      },
                      elevation: 10.0,
                      color: Colors.white,
                      splashColor: Theme.of(context).splashColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/google_logo.png",
                              height: 35.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "Sign in with Google",
                                style: Theme.of(context).textTheme.body1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      elevation: 10.0,
                      color: Theme.of(context).primaryColor,
                      splashColor: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              "Sign Up",
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Divider(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: LoginField(false),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: LoginField(true),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: RawMaterialButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Theme.of(context).primaryColor,
                      splashColor: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
