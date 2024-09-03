import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex/AllScreens/registerScreen.dart';
import 'package:codex/Services/helperFunctions.dart';
import 'package:codex/Widgets/customBottomNavBar.dart';
import 'package:codex/constants.dart';
import 'package:codex/main.dart';
import 'package:codex/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginScreen extends StatelessWidget {
  static const String screenId = "loginScreen";

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController resetPasswordEmailTEC = TextEditingController();
  QuerySnapshot? snapshot;
  String? hospital;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 35.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 39 * SizeConfig.widthMultiplier!,
                height: 25 * SizeConfig.heightMultiplier!,
                alignment: Alignment.center,
              ),
              Text(
                "Ambulance",
                style: TextStyle(
                    fontSize: 3.5 * SizeConfig.textMultiplier!,
                    fontFamily: "Brand Bold",
                    color: Color(0xFFa81845)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                "Login here",
                style: TextStyle(
                  fontSize: 3.5 * SizeConfig.textMultiplier!,
                  fontFamily: "Brand Bold",
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTEC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier!,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier!,
                        ),
                      ),
                      style:
                          TextStyle(fontSize: 2 * SizeConfig.textMultiplier!),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTEC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier!,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier!,
                        ),
                      ),
                      style:
                          TextStyle(fontSize: 2 * SizeConfig.textMultiplier!),
                    ),
                    SizedBox(
                      height: 5 * SizeConfig.heightMultiplier!,
                    ),
                    ElevatedButton(
                      clipBehavior: Clip.hardEdge,
                      // padding: EdgeInsets.zero,
                      // textColor: Colors.white,
                      // elevation: 8,
                      child: Container(
                        height: 6.5 * SizeConfig.heightMultiplier!,
                        width: 100 * SizeConfig.widthMultiplier!,
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradientColor,
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 2.5 * SizeConfig.textMultiplier!,
                              fontFamily: "Brand Bold",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // shape: new RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(24.0),
                      // ),
                      onPressed: () async {
                        bool hasInternet =
                            await InternetConnectionChecker().hasConnection;
                        if (hasInternet == true) {
                        } else {
                          displayToastMessage(
                              "No internet Connection", context);
                          return;
                        }
                        if (!emailTEC.text.contains("@")) {
                          displayToastMessage("Email address is Void", context);
                        } else if (passwordTEC.text.isEmpty) {
                          displayToastMessage("Input Password", context);
                        } else {
                          HelperFunctions.saveUserEmailSharedPref(
                              emailTEC.text.trim());
                          databaseMethods
                              .getDriverByUserEmail(emailTEC.text)
                              .then((val) {
                            snapshot = val;
                            HelperFunctions.saveUserNameSharedPref(
                                snapshot!.docs[0].get("name"));
                            authMethods
                                .signInWithEmailAndPassword(
                                    context, emailTEC.text, passwordTEC.text)
                                .then((val) {
                              if (val != null) {
                                HelperFunctions.saveUserLoggedInSharedPref(
                                    true);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomBottomNavBar(),
                                    ));
                                displayToastMessage(
                                    "Logged in Successfully", context);
                              } else {
                                displayToastMessage("Login Failed", context);
                              }
                            }).catchError((e) {
                              displayToastMessage(
                                  "Wrong email or password", context);
                            });
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20 * SizeConfig.heightMultiplier!,
              ),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: Text(
                      "Reset Password",
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier!,
                      ),
                    ),
                    content: Container(
                      height: 10 * SizeConfig.heightMultiplier!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            controller: resetPasswordEmailTEC,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Enter your email address...",
                              labelStyle: TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier!,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 1.5 * SizeConfig.textMultiplier!,
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier!),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        child: Text("Reset"),
                        onPressed: () async {
                          if (resetPasswordEmailTEC.text.isEmpty) {
                            displayToastMessage("Input Email", context);
                          } else if (!resetPasswordEmailTEC.text
                              .contains("@")) {
                            displayToastMessage("Invalid Email", context);
                          } else {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: resetPasswordEmailTEC.text);
                            Navigator.of(context).pop();
                            showSimpleNotification(
                              Text(
                                "A password reset link has been sent to ${resetPasswordEmailTEC.text}",
                                style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  color: Colors.grey[100],
                                ),
                              ),
                              background: Colors.black54,
                              duration: Duration(seconds: 5),
                              elevation: 0,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                child: Text(
                  "Forgot Password?!",
                  style: TextStyle(
                    color: Color(0xFFa81845),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterScreen.screenId, (route) => false);
                },
                child: Text(
                  "Don't have an Account? Register Here",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color(0xFFa81845),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

displaySnackBar(
    {@required String? message,
    required BuildContext context,
    Function? onPressed,
    String? label,
    Duration? duration}) {
  SnackBar snackBar = SnackBar(
    duration: duration != null ? duration : Duration(seconds: 4),
    content: Text(message!),
    action: SnackBarAction(
      label: label != null ? label : "Cancel",
      onPressed: (onPressed != null ? onPressed : () {}) as VoidCallback,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
