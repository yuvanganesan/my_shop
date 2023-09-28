import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool? favourite = false;

  Product(
      {this.id,
      this.description,
      this.favourite,
      this.imageUrl,
      this.price,
      this.title});

  void _setFavVal(bool value) {
    this.favourite = value;
    notifyListeners();
  }

  void isFavourite(String authToken, String userId) async {
    final oldStatus = favourite;
    this.favourite = this.favourite == true ? false : true;
    notifyListeners();
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(url, body: json.encode(this.favourite));
      if (response.statusCode >= 400) {
        print(response.statusCode);
        _setFavVal(oldStatus!);
      }
    } catch (_) {
      _setFavVal(oldStatus!);
    }
  }
}
