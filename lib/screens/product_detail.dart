import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provoiders/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "product-detai";
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context)!.settings.arguments as String;
    final _productDetail =
        Provider.of<Products>(context, listen: false).productWithId(_productId);
    //print("detail screen");
    return Scaffold(
      //  appBar: AppBar(title: Text(_productDetail.title!)),
      body: CustomScrollView(
        //reverse: true,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            // title: Text('product'),

            pinned: true,

            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _productDetail.title!,
                  style: TextStyle(backgroundColor: Colors.black45),
                ),
                // background: Container(color: Theme.of(context).primaryColor),
                background: Hero(
                  tag: _productId,
                  child: Image.network(
                    _productDetail.imageUrl!,
                    fit: BoxFit.fill,
                  ),
                )),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.grey,
                ),
                Text(
                  "${_productDetail.price}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _productDetail.description!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(
              height: 600,
            )
          ]))
        ],
      ),
    );
  }
}
