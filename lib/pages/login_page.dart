import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitter/services/firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuthService authService = FirebaseAuthService();

  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _showSnackBar() {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Incorrect credentials",
            style: Theme.of(context).textTheme.body1.apply(color: Colors.red),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _loginFormKey,
        child: Center(
          child: Container(
            child: SingleChildScrollView(
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
                        FirebaseUser user =
                            await authService.signInWithGoogle();
                        if (user != null) {
                          Navigator.of(context).pushReplacementNamed(
                            "/home",
                          );
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
                        Navigator.of(context).pushNamed(
                          "/signup",
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
                    child: Material(
                      elevation: 10.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        child: TextFormField(
                          validator: (value) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid e-mail';
                            }

                            return null;
                          },
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "E-mail",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Material(
                      elevation: 10.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a password";
                            } else {
                              return null;
                            }
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none, labelText: "Password"),
                        ),
                      ),
                    ),
                  ),

                  /**
                   * Sign in button
                   */
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: RawMaterialButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_loginFormKey.currentState.validate()) {
                                _loginFormKey.currentState.save();

                                FirebaseUser user = await authService
                                    .signInWithEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text);
                                if (user != null) {
                                  Navigator.of(context).pushReplacementNamed(
                                    "/home",
                                  );
                                } else {
                                  _showSnackBar();
                                }
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                backgroundColor: Theme.of(context).splashColor,
                                strokeWidth: 4.0,
                              )
                            : Icon(
                                Icons.arrow_forward,
                              ),
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Theme.of(context).primaryColor,
                      splashColor: Theme.of(context).accentColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
