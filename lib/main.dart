import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product.dart';
import '../screens/order_screen.dart';
import '../screens/user_products.dart';
import '../provoiders/orders.dart';
import './screens/cart_screen.dart';
import './provoiders/cart.dart';
import './screens/product_detail.dart';
import './screens/product_overview_screen.dart';
import './provoiders/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(create: ((context) => CartItem())),
        ChangeNotifierProvider(create: ((context) => Orders()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
            fontFamily: "Lato",
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetail.routeName: ((context) => ProductDetail()),
          CartScreen.routeName: ((context) => CartScreen()),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProducts.routeName: (context) => UserProducts(),
          EditProduct.routeName: (context) => EditProduct()
        },
      ),
    );
  }
}
