
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/auth_methods.dart';

class User_provider with ChangeNotifier{
   User? _user;
   User get getUser => _user!;
   final Auth_meths auth_meths = Auth_meths();

   Future<void> refreshUser() async {
     User user = await auth_meths.gwt_userdets();

     _user = user;
     notifyListeners();
   }
}