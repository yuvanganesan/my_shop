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
import './screens/auth_screen.dart';
import './provoiders/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

   //const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => Auth())),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (context) => Products("token", [], "userId"),
              update: ((context, auth, previousProducts) => Products(
                  auth.token,
                  previousProducts == null ? [] : previousProducts.getItem,
                  auth.userId))),
          ChangeNotifierProvider(create: ((context) => CartItem())),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (context) => Orders("token", [], "userId"),
              update: ((context, auth, previousOrders) => Orders(
                  auth.token,
                  previousOrders == null ? [] : previousOrders.orders,
                  auth.userId)))
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
                fontFamily: "Lato",
                primarySwatch: Colors.purple,
                hintColor: Colors.deepOrange),
            home: !auth.isAuth
                ? FutureBuilder(
                    future: auth.tryAutoSignIn(),
                    builder: ((context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()))
                : ProductOverviewScreen(),
            routes: {
              ProductDetail.routeName: ((context) => ProductDetail()),
              CartScreen.routeName: ((context) => CartScreen()),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProducts.routeName: (context) => UserProducts(),
              EditProduct.routeName: (context) => EditProduct()
            },
          ),
        ));
  }
}
