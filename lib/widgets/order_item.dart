import 'package:flutter/material.dart';
import '../provoiders/orders.dart' as so;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final so.OrderItem order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text("₹${widget.order.amount}"),
          subtitle: Text(
              "${DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime)}"),
          trailing: IconButton(
            icon:
                Icon(_isExpand == true ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _isExpand = !_isExpand;
              });
            },
          ),
        ),
        if (_isExpand == true)
          Container(
            height: min(widget.order.products.length * 15.0 + 40, 150),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ListView(children: [
              ...widget.order.products
                  .map((pro) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pro.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("${pro.quantity} x ₹${pro.price}  ")
                        ],
                      ))
                  .toList()
            ]),
          ),
      ]),
    );
  }
}
