import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../provoiders/products.dart';

class ProductGrid extends StatelessWidget {
  final _filterChoice;
  ProductGrid(this._filterChoice);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final products = _filterChoice == FilterOption.Favourite
        ? productData.getFavourite
        : productData.getItem;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (cxt, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
