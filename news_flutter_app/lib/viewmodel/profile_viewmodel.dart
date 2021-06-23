import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_flutter_app/model/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  UserEntity? user;
  String? errorMessage;
  bool? doHaveAccount;

  UserEntity? get getUserInfo => user;

  String? get getErrorMessage => errorMessage;

  bool? get userHaveAccount => doHaveAccount;

  void validateHaveAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final UserEntity? user =
        UserEntity.fromJson(json.decode(prefs.getString('credentials')!));
    if (user == null) {
      this.doHaveAccount = false;
    } else {
      this.doHaveAccount = true;
    }
    notifyListeners();
  }

  void login(String? username, String? password) async {
    print('LOGIN : $username : $password');
    final result = validate(username, password);
    if (result != null) {
      this.errorMessage = result;
    } else {
      this.errorMessage = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final user =
          UserEntity.fromJson(json.decode(prefs.getString('credentials')!));
      print('USER NAME : ${user.username}');
      print('PASSWORD : ${user.password}');
      if (user.username != username || user.password != password) {
        this.errorMessage = 'Wrong credentials, please check again';
        print('NON MATCH');
      } else {
        print('MATCH');
        this.errorMessage = null;
        this.user = user;
      }
    }
    notifyListeners();
  }

  void createNewAccount(String? username, String? password) async {
    print('CREATE NEW ACCOUNT');
    final result = validate(username, password);
    if (result != null) {
      this.errorMessage = result;
    } else {
      this.errorMessage = null;
      UserEntity user = new UserEntity(username!, password!);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userString = json.encode(user.toJson());
      prefs.setString('credentials', userString);
      print('USER STRING : $userString');
      this.user = user;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    print('ProfileViewModel was disposed.');
    super.dispose();
  }
}

String? validate(String? username, String? password) {
  if (username == null || username.length < 5) {
    return 'Username must be greater then 5';
  }
  if (password == null || password.length < 6) {
    return 'Password must be grater then 6';
  }
  return null;
}
