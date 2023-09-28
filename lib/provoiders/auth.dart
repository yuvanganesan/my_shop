import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../modles/httpException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _timeOut;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB_i4SSCS2WqQhgOp6Qo7tfBJCWRkXIoW4');
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // print(json.decode(response.body));

      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_timeOut != null) {
      _timeOut!.cancel();
      _timeOut = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (_timeOut != null) {
      _timeOut!.cancel();
    }
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _timeOut = Timer(Duration(seconds: timeToExpire), logOut);
  }

  Future<bool> tryAutoSignIn() async {
    final pref = await SharedPreferences.getInstance();

    if (!pref.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(pref.getString('userData')!);

    final expiryDate = extractedUserData['expiryDate'];
    //print(expiryDate);

    if (DateTime.parse(expiryDate).isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token']; // as String?;
    _userId = extractedUserData['userId']; // as String?;
    _expiryDate = DateTime.parse(expiryDate); //expiryDate as DateTime?;

    notifyListeners();
    autoLogout();

    return true;
  }
}
