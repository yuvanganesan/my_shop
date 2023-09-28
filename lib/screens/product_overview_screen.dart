import 'package:flutter/material.dart';
import '../provoiders/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart' as bg;
import '../provoiders/products.dart';
import '../widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOption { Favourite, ShowAll }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  FilterOption? _filterChoice;
  bool _isFirst = false;
  bool progressIndicator = false;
  int _contentIndex = 0;

  @override
  void didChangeDependencies() async {
    if (!_isFirst) {
      setState(() {
        progressIndicator = true;
      });
      try {
        await Provider.of<Products>(context).fetchAndLoadProdcts();
      } catch (error) {
        //  if (error.toString() == "There is no product") {
        await showDialog(
            context: context,
            builder: (context) {
              _contentIndex = 1;
              return AlertDialog(
                title: Text("Something Went Wrong"),
                content: Text("There is No Products "),
                actions: [
                  ElevatedButton(
                      onPressed: (() => Navigator.of(context).pop()),
                      child: Text("Okay"))
                ],
              );
            });
        //}
      } finally {
        setState(() {
          progressIndicator = false;
        });
        _isFirst = true;
      }
    }
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero)
  //       .then((_) => Provider.of<Products>(context).fetchAndLoadProdcts());

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> _content = [
      ProductGrid(_filterChoice),
      Center(
        child: Image.asset("assets/images/NoProFo.jpg"),
      )
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("MyShop"),
          actions: [
            PopupMenuButton(
              onSelected: (filterOption) {
                setState(() {
                  _filterChoice = filterOption as FilterOption?;
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text("Only Favourite"),
                  value: FilterOption.Favourite,
                ),
                PopupMenuItem(
                  child: Text("Show All"),
                  value: FilterOption.ShowAll,
                ),
              ],
            ),
            Consumer<CartItem>(
                builder: (context, _cart, child) => bg.Badge(
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                      ),
                      value: _cart.itemCount().toString(),
                    ))
          ],
        ),
        drawer: AppDrawer(),
        body: progressIndicator
            ? Center(child: CircularProgressIndicator())
            //LinearProgressIndicator()
            : _content[_contentIndex] //ProductGrid(_filterChoice),
        );
  }
}



//  bool _isLoading;
//   @override
//   void initState() {
//     _isLoading = true;
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("MyShop")),
//       body: _isLoading
//           ? Center(
//               child: Shimmer(),
//             )
//           : ProductGrid(),
//     );
//   }
