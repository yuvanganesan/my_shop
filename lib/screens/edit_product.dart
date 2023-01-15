import 'package:flutter/material.dart';
import '../provoiders/product.dart';
import 'package:provider/provider.dart';
import '../provoiders/products.dart';

class EditProduct extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageURlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _dataInsertState = false;
  var _editProduct = Product(
      id: null,
      price: 0,
      title: "",
      description: "",
      imageUrl: "",
      favourite: false);
  String _productId;
  bool isInit = true;
  var initialData = {
    "id": "",
    "title": "",
    "discription": "",
    "price": "",
    // "imageUrl": ""
  };

  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _productId = ModalRoute.of(context).settings.arguments as String;
      if (_productId != null) {
        _editProduct = Provider.of<Products>(context, listen: false)
            .productWithId(_productId);
        initialData = {
          "id": _editProduct.id,
          "title": _editProduct.title,
          "description": _editProduct.description,
          "price": _editProduct.price.toString(),
          // "imageUrl": _editProduct.imageUrl
        };
        _imageURlController.text = _editProduct.imageUrl;
      }
    }
    isInit = false;

    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _dataInsertState = true;
    });

    if (_editProduct.id == null) {
      try {
        _form.currentState.save();
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Something went wrong"),
                  content: Text("An error accured in firebase"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          // print("success");
                          // setState(() {
                          //   _dataInsertState = false;
                          // });
                          // Navigator.of(context).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      }
      //   finally {
      //     //  print("success");
      //     setState(() {
      //       _dataInsertState = false;
      //     });
      //     Navigator.of(context).pop();
      //   }
    } else {
      _form.currentState.save();
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    }
    setState(() {
      _dataInsertState = false;
    });
    Navigator.of(context).pop();

    // print(_editProduct.title);
    // print(_editProduct.price);
    // print(_editProduct.description);
    // print(_editProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _dataInsertState
          ? //LinearProgressIndicator()
          Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initialData['title'],
                        decoration: InputDecoration(label: Text("Title")),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              favourite: _editProduct.favourite,
                              price: _editProduct.price,
                              title: value,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter title";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initialData['price'],
                        decoration: InputDecoration(label: Text("Price")),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              favourite: _editProduct.favourite,
                              price: double.parse(value),
                              title: _editProduct.title,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl);
                        },
                        validator: (Value) {
                          if (Value.isEmpty) {
                            return "Please enter price";
                          }
                          if (double.tryParse(Value) == null) {
                            return "Please enter valid price";
                          }
                          if (double.parse(Value) <= 0) {
                            return "Please enter minimum price";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initialData['description'],
                        decoration: InputDecoration(label: Text("Description")),
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              favourite: _editProduct.favourite,
                              price: _editProduct.price,
                              title: _editProduct.title,
                              description: value,
                              imageUrl: _editProduct.imageUrl);
                        },
                        validator: (Value) {
                          if (Value.isEmpty) {
                            return "Please enter description";
                          }
                          if (Value.length <= 10) {
                            return "Should be the length minimum 10";
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            //color: Colors.grey,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            margin: EdgeInsets.only(top: 8, right: 10),
                            child: _imageURlController.text.isEmpty
                                ? Text("Enter a Url")
                                : FittedBox(
                                    child:
                                        Image.network(_imageURlController.text),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(label: Text("Image URL")),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageURlController,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                              onSaved: (value) {
                                _editProduct = Product(
                                    id: _editProduct.id,
                                    favourite: _editProduct.favourite,
                                    price: _editProduct.price,
                                    title: _editProduct.title,
                                    description: _editProduct.description,
                                    imageUrl: value);
                              },
                              validator: (Value) {
                                if (Value.isEmpty) {
                                  return "Please enter Url";
                                }
                                if (!Value.startsWith("http") ||
                                    !Value.startsWith("https")) {
                                  return "Please enter valid url";
                                }
                                if (!Value.endsWith(".jpg") &&
                                    !Value.endsWith(".png") &&
                                    !Value.endsWith("jpeg")) {
                                  return "Enter valid img url";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
