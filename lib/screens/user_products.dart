import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_product.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import '../provoiders/products.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {
  static const routeName = "/User-Product-Sceen";
  @override
  Widget build(BuildContext context) {
    final _productItem = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Products>(context, listen: false)
              .fetchAndLoadProdcts();
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: ((context, index) => UserProductItem(
                _productItem.getItem[index].id,
                _productItem.getItem[index].title,
                _productItem.getItem[index].imageUrl)),
            itemCount: _productItem.getItem.length,
          ),
        ),
      ),
    );
  }
}
