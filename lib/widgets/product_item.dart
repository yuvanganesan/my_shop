import "package:flutter/material.dart";
import '../provoiders/cart.dart';
import '../screens/product_detail.dart';
import 'package:provider/provider.dart';
import '../provoiders/product.dart';
import '../provoiders/auth.dart';

class ProductItem extends StatelessWidget {
  // final Product _productItem;
  // ProductItem(this._productItem);

  @override
  Widget build(BuildContext context) {
    final Product _productItem = Provider.of<Product>(context, listen: false);
    final CartItem _cartItem = Provider.of<CartItem>(context, listen: false);
    final Auth _auth = Provider.of<Auth>(context, listen: false);

    // print("product item");
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, _productItem, _) {
                //print("product item consumer");
                return IconButton(
                  color: Colors.deepOrange,
                  icon: _productItem.favourite == true
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    _productItem.isFavourite(_auth.token!, _auth.userId!);
                  },
                );
              },
            ),
            title: Text(
              _productItem.title!,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                _cartItem.addItem(
                    _productItem.id!, _productItem.price!, _productItem.title!);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Item has been add to cart"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      _cartItem.removeSingleItem(_productItem.id!);
                    },
                  ),
                ));
              },
            )),
        child: GestureDetector(
            onTap: (() {
              Navigator.of(context).pushNamed(ProductDetail.routeName,
                  arguments: _productItem.id);
            }),
            child: Hero(
                tag: _productItem.id as Object,
                child: FadeInImage(
                    placeholder: AssetImage('assets/images/loadingSpiner.png'),
                    image: NetworkImage(_productItem.imageUrl!),
                    fit: BoxFit.fill))),
      ),
    );
  }
}
