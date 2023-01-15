import 'package:flutter/material.dart';
import '../provoiders/product.dart';
import 'package:provider/provider.dart';
import '../provoiders/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "product-detai";
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final _productDetail =
        Provider.of<Products>(context, listen: false).productWithId(_productId);
    print("detail screen");
    return Scaffold(
      appBar: AppBar(title: Text(_productDetail.title)),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(border: Border.all(width: 7)),
              width: double.infinity,
              height: 300,
              child: Image.network(
                _productDetail.imageUrl,
                fit: BoxFit.fill,
              ))
        ],
      ),
    );
  }
}
