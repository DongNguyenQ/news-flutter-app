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
    final userString = prefs.getString('credentials');
    if (userString == null) {
      this.doHaveAccount = false;
    } else {
      this.doHaveAccount = true;
    }
    notifyListeners();
  }

  void finishShowErrorMessage() {
    this.errorMessage = null;
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
      print('USER NAME EXISTED : ${user.username}');
      print('PASSWORD EXISTED : ${user.password}');
      if (user.username != username) {
        this.errorMessage = 'Wrong username, please check again';
      } else if (user.password != password) {
        this.errorMessage = 'Wrong password, please check again';
      } else {
        this.errorMessage = null;
        this.user = user;
      }
    }
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  void logout() {
    this.user = null;
    this.errorMessage = '';
    this.doHaveAccount = true;
    print('IS NULL : ${this.user == null}');
    notifyListeners();
  }

  void createNewAccount(String? username, String? password) async {
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
