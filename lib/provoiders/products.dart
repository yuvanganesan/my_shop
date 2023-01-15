import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/modles/httpException.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get getItem {
    // if (isFavourite == true) {
    //   return [..._items.where((product) => product.favourite == true).toList()];
    // } else {
    return [..._items];
    //}
  }

  List<Product> get getFavourite {
    return [..._items.where((product) => product.favourite == true).toList()];
  }

  // void favouriteOnly() {
  //   isFavourite = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   isFavourite = false;
  //   notifyListeners();
  // }

  Product productWithId(String productId) {
    return _items.firstWhere((product) => productId == product.id);
  }

  Future<void> fetchAndLoadProdcts() async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      //print(response.statusCode);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> productFetch = [];
      if (loadedData == null) {
        // _items = productFetch;
        // notifyListeners();
        throw HttpException("There is no product");
      }

      loadedData.forEach((key, value) {
        productFetch.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'].toDouble(),
            imageUrl: value['imageUrl'],
            favourite: value['isFavourite']));
      });
      _items = productFetch;
      // print(_items);
      notifyListeners();
    } catch (error) {
      print("this is error : " + error);
      throw error;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/products.json');
    try {
      print("favourite status : ${newProduct.favourite}");
      final response = await http.post(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavourite': newProduct.favourite
          }));

      print(json.decode(response.body));
      _items.add(Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateProduct(String productId, Product existingProduct) async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/products/$productId.json');
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    if (productIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': existingProduct.title,
            'description': existingProduct.description,
            'price': existingProduct.price,
            'imageUrl': existingProduct.imageUrl,
          }));
      _items[productIndex] = existingProduct;
    } else {
      print("...product not found");
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://myshop-ba200-default-rtdb.firebaseio.com/products/$productId.json');
    final existingIndex =
        _items.indexWhere((element) => element.id == productId);
    if (existingIndex != -1) {
      var existingProduct = _items[existingIndex];
      _items.removeAt(existingIndex);
      notifyListeners();
      final response = await http.delete(url);
      // print(response.statusCode);
      if (response.statusCode >= 400) {
        _items.insert(existingIndex, existingProduct);

        notifyListeners();
        throw HttpException("Can't delete product");
      }
      existingProduct = null;

      //_items.removeWhere((element) => element.id == productId);

    }
  }
}
