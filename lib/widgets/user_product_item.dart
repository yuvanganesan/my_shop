import 'package:flutter/material.dart';
import '../screens/edit_product.dart';
import 'package:provider/provider.dart';
import '../provoiders/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String productTitle;
  final String imaageUrl;

  UserProductItem(this.id, this.productTitle, this.imaageUrl);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(imaageUrl)),
            title: Text(productTitle),
            trailing: Container(
                width: 98,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditProduct.routeName, arguments: id);
                      },
                      icon: Icon(Icons.edit),
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          await Provider.of<Products>(context, listen: false)
                              .deleteProduct(id);
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            "Deleting Failed!",
                            textAlign: TextAlign.center,
                          )));
                        }
                      },
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                    )
                  ],
                )),
          ),
        ));
  }
}
