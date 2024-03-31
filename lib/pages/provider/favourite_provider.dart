import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouriteProductProvider extends ChangeNotifier {
  List product = [];
  CollectionReference favProductCol = FirebaseFirestore.instance
      .collection('MeowMeowCat')
      .doc('Users')
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .doc('Favourite')
      .collection('items');
  Future addToFavourite(Map item) async {
    await favProductCol
        .doc(Timestamp.fromDate(DateTime.now())
            .millisecondsSinceEpoch
            .toString())
        .set({
      'Product_ID': item['Product_ID'],
      'name': item['name'],
      'pathImg': item['pathImg'],
      'price': item['price'],
      'detail': item['detail'],
    });
    debugPrint("Added to favourite");

    final favItems = await favProductCol.get();
    product = favItems.docs.map((doc) => doc.data()).toList();
  }

  void addListProduct(List item) {
    product = item;
    log(product.toString());
  }

  Future removeToFavourite(String productId) async {
    try {
      final querySnapshot =
          await favProductCol.where("Product_ID", isEqualTo: productId).get();
      final batch = FirebaseFirestore.instance.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (error) {
      debugPrint("Failed to remove item: $error");
    }
    product.removeWhere((item) => item['Product_ID'] == productId);
    log("removefav");

    notifyListeners();
  }

  void clearListFavProduct() {
    product.clear();
  }
}
