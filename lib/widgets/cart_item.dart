import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../provoiders/cart.dart' as ci;

class CartItem extends StatelessWidget {
  final String id; //cart id
  final String productId; //product id baced on product provider
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: ((direction) {
        Provider.of<ci.CartItem>(context, listen: false).removeItem(productId);
      }),
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      ),
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Are you sure?"),
                content: Text("Do yoy want to delete product from cart?"),
                actions: [
                  TextButton(
                      onPressed: (() {
                        return Navigator.of(context).pop(false);
                      }),
                      child: Text("No")),
                  TextButton(
                      onPressed: (() {
                        return Navigator.of(context).pop(true);
                      }),
                      child: Text("Yes"))
                ],
              );
            });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                    child: Text(
                  "₹${price}",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total ₹${price * quantity}"),
            trailing: Text("${quantity} X"),
          ),
        ),
      ),
    );
  }
}
