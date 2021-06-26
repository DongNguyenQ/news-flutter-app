import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_flutter_app/model/user_entity.dart';
import 'package:news_flutter_app/utils/const.dart';
import 'package:news_flutter_app/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpViewModel extends ChangeNotifier {
  UserEntity? _createdUser;
  String? _errorMessage;
  bool _isBusy = false;

  bool get isBusy => _isBusy;

  String? get getErrorMessage => _errorMessage;

  UserEntity? get getCreatedUser => _createdUser;

  Future<void> signup(String? username, String? password) async {
    print('CREATE NEW ACCOUT');
    _setBusy(true);
    _resetError();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentUser =
        UserEntity.fromJson(json.decode(prefs.getString('credentials')!));

    if (username == currentUser.username) {
      this._errorMessage = 'User name already existed';
    } else {
      final resultValidated = validate(username!, password!);
      if (resultValidated != null) {
        this._errorMessage = resultValidated;
      } else {
        final user = UserEntity(username, password);
        prefs.clear();
        prefs.setString(
            userLocalStorageKey,
            json.encode(user.toJson()));
        this._createdUser = user;
        print('CREATED NEW USER SUCCESS');
      }
    }
    _setBusy(false);
  }

  void _setBusy(bool isBusy) {
    this._isBusy = isBusy;
    notifyListeners();
  }

  void _resetError() {
    this._errorMessage = null;
    notifyListeners();
  }
}