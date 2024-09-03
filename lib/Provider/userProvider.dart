import 'package:codex/Models/user.dart';
import 'package:codex/Services/database.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  DatabaseMethods _databaseMethods = DatabaseMethods();

  User get getUser {
    return _user!;
  }

  void refreshDriver() async {
    User user = await _databaseMethods.getDriverDetails();
    _user = user;
    notifyListeners();
  }
}
