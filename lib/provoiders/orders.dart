import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provoiders/product.dart';
import '../provoiders/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  OrderItem(@required this.id, @required this.amount, @required this.products,
      @required this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndLoadOrders() async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    List<OrderItem> loadedData = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, order) {
      loadedData.add(OrderItem(
          orderId,
          order['amount'],
          (order['products'] as List<dynamic>)
              .map((item) => Cart(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
          DateTime.parse(order['dateTime'])));
    });
    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> products, double total) async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/orders.json');
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
