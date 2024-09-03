import 'dart:io';

import 'package:codex/AllScreens/driverRegistrationScreen.dart';
import 'package:codex/AllScreens/loginScreen.dart';
import 'package:codex/Services/auth.dart';
import 'package:codex/Services/database.dart';
import 'package:codex/Services/helperFunctions.dart';
import 'package:codex/Utilities/utils.dart';
import 'package:codex/constants.dart';
import 'package:codex/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class RegisterScreen extends StatefulWidget {
  static const String screenId = "registerScreen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();
  String? profilePhoto;

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
                height: 4 * SizeConfig.heightMultiplier!,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 39 * SizeConfig.widthMultiplier!,
                height: 25 * SizeConfig.heightMultiplier!,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Ambulance",
                style: TextStyle(
                  fontSize: 3.5 * SizeConfig.textMultiplier!,
                  fontFamily: "Brand Bold",
                  color: Color(0xFFa81845),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                "Register here",
                style: TextStyle(
                    fontSize: 6 * SizeConfig.imageSizeMultiplier!,
                    fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: nameTEC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phoneTEC,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
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
                      height: 1.0,
                    ),
                    TextField(
                      controller: confirmPasswordTEC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
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
                      height: 10.0,
                    ),
                    ElevatedButton(
                      clipBehavior: Clip.hardEdge,
                      // padding: EdgeInsets.zero,
                      // elevation: 8,
                      // textColor: Colors.white,
                      child: Container(
                        height: 6.5 * SizeConfig.heightMultiplier!,
                        width: 100 * SizeConfig.widthMultiplier!,
                        decoration:
                            BoxDecoration(gradient: kPrimaryGradientColor),
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 2.5 * SizeConfig.textMultiplier!,
                              fontFamily: "Brand Bold",
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
                        if (nameTEC.text.length <= 4) {
                          displayToastMessage(
                              "Name must be at least 4 characters ", context);
                        } else if (!emailTEC.text.contains("@")) {
                          displayToastMessage("Email address is Void", context);
                        } else if (phoneTEC.text.isEmpty) {
                          displayToastMessage(
                              "Phone Number is necessary", context);
                        } else if (passwordTEC.text.length <= 7) {
                          displayToastMessage(
                              "Password must be at least 7 Characters",
                              context);
                        } else if (confirmPasswordTEC.text !=
                            passwordTEC.text) {
                          displayToastMessage(
                              "Passwords are not the same", context);
                        } else {
                          String name = nameTEC.text.trim();
                          String email = emailTEC.text.trim();
                          String phone = phoneTEC.text.trim();
                          String password = passwordTEC.text.trim();
                          print("here");
                          bool emailCheck =
                              await HelperFunctions.saveUserEmailSharedPref(
                                  email);
                          bool nameCheck =
                              await HelperFunctions.saveUserNameSharedPref(
                                  name);

                          if (context.mounted && emailCheck && nameCheck) {
                            authMethods
                                .signUpWithEmailAndPassword(
                                    context, email, password)
                                .then((val) {
                              if (val != null) {
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DriverRegistration(
                                        val: val,
                                        name: name,
                                        email: email,
                                        phone: phone,
                                        password: password,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted)
                                  displayToastMessage(
                                      "Creating New driver account Failed",
                                      context);
                              }
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.screenId, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(
                    color: Color(0xFFa81845),
                    decoration: TextDecoration.underline,
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

class DropDownList extends StatefulWidget {
  String selectedValue = "";
  final List listItems;
  final String placeholder;
  DropDownList({Key? key, required this.listItems, required this.placeholder})
      : super(key: key);

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  String? valueChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton(
        hint: Text(widget.placeholder),
        style: TextStyle(
            fontSize: 2 * SizeConfig.textMultiplier!, color: Colors.black54),
        dropdownColor: Colors.white,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFFa81845),
        ),
        iconSize: 8 * SizeConfig.imageSizeMultiplier!,
        isExpanded: true,
        value: valueChoose,
        onChanged: (newValue) {
          setState(() {
            valueChoose = newValue as String;
            widget.selectedValue = valueChoose!;
          });
        },
        items: widget.listItems.map((valueItem) {
          return DropdownMenuItem(
            value: valueItem,
            child: Text(valueItem),
          );
        }).toList(),
      ),
    );
  }
}

Future pickImage(
    {required ImageSource source,
    required BuildContext context,
    required DatabaseMethods databaseMethods}) async {
  File? selectedImage = await Utils.pickImage(source: source);
  if (selectedImage != null) {
    String? url = await databaseMethods.uploadImageToStorage(selectedImage);
    return url;
  } else {
    displayToastMessage("No Image Selected!", context);
  }
}
