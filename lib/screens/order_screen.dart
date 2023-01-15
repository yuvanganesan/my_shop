import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import '../provoiders/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order";

  @override
  Widget build(BuildContext context) {
    //  final orderData =
    return Scaffold(
        appBar: AppBar(title: Text("Your Orders")),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndLoadOrders(),
          builder: (context, buildData) {
            if (buildData.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (buildData.error != null) {
                return Center(
                  child: Text("Opps there some error occured"),
                );
              } else {
                return Consumer<Orders>(builder: ((context, orderData, child) {
                  return ListView.builder(
                    itemBuilder: ((context, index) {
                      return OrderItem(orderData.orders[index]);
                    }),
                    itemCount: orderData.orders.length,
                  );
                }));
              }
            }
          },
        ));
  }
}

//  @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) async {
//       setState(() {
//         _isLoaded = true;
//       });
//       await Provider.of<Orders>(context, listen: false).fetchAndLoadOrders();
//       setState(() {
//         _isLoaded = false;
//       });
//     });
//     super.initState();
//   }

// void initState() {
//   setState(() {
//     _isLoaded = true;
//   });
//   Provider.of<Orders>(context, listen: false).fetchAndLoadOrders();
//   setState(() {
//     _isLoaded = false;
//   });

//   super.initState();
// }
