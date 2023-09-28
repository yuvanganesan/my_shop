import 'dart:js_interop';

import 'package:flutter/material.dart';
import '../provoiders/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final token;
  final userId;
  Orders(this.token, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndLoadOrders() async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final response = await http.get(url);
    List<OrderItem> loadedData = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isNull) {
      return;
    }
    // print(extractedData);

    extractedData.forEach((orderId, order) {
      // print(order['amount'].runtimeType);
      loadedData.add(OrderItem(
          orderId,
          double.parse("${order['amount']}"),
          (order['products'] as List<dynamic>)
              .map((item) => Cart(
                  id: item['id'],
                  title: item['title'],
                  price: double.parse(item['price'].toString()),
                  quantity: item['quantity']))
              .toList(),
          DateTime.parse(order['dateTime'])));
    });
    _orders = loadedData.reversed.toList();
    // print('reached');
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> products, double total) async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final dateTime = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': dateTime.toIso8601String(),
          'products': products
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            json.decode(response.body)['name'], total, products, dateTime));
  }
}
