import 'package:flutter/material.dart';
import '../provoiders/orders.dart' as so;
import 'package:intl/intl.dart';

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
      child: AnimatedContainer(
        // decoration: BoxDecoration(border: Border.all(width: 2)),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height:
            _isExpand ? (widget.order.products.length * 15.0 + 50) + 110 : 80,
        margin: EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            title: Text("₹${widget.order.amount}"),
            subtitle: Text(
                "${DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime)}"),
            trailing: IconButton(
              icon: Icon(
                  _isExpand == true ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpand = !_isExpand;
                });
              },
            ),
          ),
          // if (_isExpand == true)
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            //min(widget.order.products.length * 15.0 + 40, 150)
            height: _isExpand ? widget.order.products.length * 15.0 + 50 : 0,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ListView(children: [
              ...widget.order.products
                  .map((pro) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pro.title!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("${pro.quantity} x ₹${pro.price}  ")
                        ],
                      ))
                  .toList()
            ]),
          ),
        ]),
      ),
    );
  }
}
