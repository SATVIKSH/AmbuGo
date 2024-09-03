import 'package:codex/AllScreens/historyPage.dart';
import 'package:codex/AllScreens/homePage.dart';
import 'package:codex/AllScreens/loginScreen.dart';
import 'package:codex/AllScreens/ratingsPage.dart';
import 'package:codex/AllScreens/registerScreen.dart';
import 'package:codex/AllScreens/userAccount.dart';
import 'package:codex/Widgets/customBottomNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  RegisterScreen.screenId: (context) => RegisterScreen(),
  HomePage.screenId: (context) => HomePage(),
  LoginScreen.screenId: (context) => LoginScreen(),
  UserAccount.screenId: (context) => UserAccount(),
  CustomBottomNavBar.screenId: (context) => CustomBottomNavBar(),
  RatingsPage.screenId: (context) => RatingsPage(),
  HistoryPage.screenId: (context) => HistoryPage(),
};
