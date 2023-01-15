import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provoiders/orders.dart';
import '../provoiders/cart.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = "/cartScreen";

  @override
  Widget build(BuildContext context) {
    CartItem _cartItem = Provider.of<CartItem>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        "₹ ${_cartItem.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  OrderNowButton(cartItem: _cartItem)
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: ((context, index) => ci.CartItem(
                _cartItem.getItem.values.toList()[index].id,
                _cartItem.getItem.keys.toList()[index],
                _cartItem.getItem.values.toList()[index].price,
                _cartItem.getItem.values.toList()[index].quantity,
                _cartItem.getItem.values.toList()[index].title)),
            itemCount: _cartItem.itemCount(),
          ))
        ],
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key key,
    @required CartItem cartItem,
  })  : _cartItem = cartItem,
        super(key: key);

  final CartItem _cartItem;

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  bool _isOrdered = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white, onPrimary: Theme.of(context).primaryColor),
        onPressed: widget._cartItem.totalAmount <= 0
            ? null
            : () async {
                setState(() {
                  _isOrdered = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget._cartItem.getItem.values.toList(),
                    widget._cartItem.totalAmount);
                setState(() {
                  _isOrdered = false;
                });
                widget._cartItem.clearCart();
              },
        child: _isOrdered == true
            ? CircularProgressIndicator()
            : Text(
                "Order Now",
                style: TextStyle(),
              ));
  }
}
