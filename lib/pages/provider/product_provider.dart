import 'package:flutter/material.dart';
import 'dart:developer';

class ProductProvider extends ChangeNotifier {
  List product = [];

  void addListProduct(List item) {
    product = item;
    log(product.toString());
  }

  void updateListProduct(List item) {
    for (var newproduct in item) {
      product
          .where((prod) => prod["Product_ID"] == newproduct["Product_ID"])
          .forEach((matchedProd) {
        matchedProd["price"] = newproduct["price"];
      });
    }
    // log('updateListProduct');
    // log(product.toString());
    notifyListeners();
  }
}
