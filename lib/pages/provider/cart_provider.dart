import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  CollectionReference addCart = FirebaseFirestore.instance
      .collection('MeowMeowCat')
      .doc('Users')
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .doc('Cart')
      .collection('items');
  int counter = 1;
  // int value = 0;
  // int totalPrice = 0;
  int get cartunit => cartList.fold<int>(0,
      (previousValue, element) => previousValue + int.parse(element['unit']));
  int get totalPrice => cartList.fold<int>(
      0,
      (previousValue, element) =>
          previousValue +
          (int.parse(element['unit']) * int.parse(element['price'])));
  List cartList = [];
  int get value => cartList.length;
  void addcartList(List item) {
    cartList = item;
    // log(cartList.toString());
    // log(cartList.length.toString());
  }

  void updatecartList(List item) {
    for (var newproduct in item) {
      cartList
          .where((cart) => cart["Product_ID"] == newproduct["Product_ID"])
          .forEach((matchedProd) {
        matchedProd["price"] = newproduct["price"];
      });
    }
    for (var newproduct in item) {
      String productId = newproduct["Product_ID"];
      String newPrice = newproduct["price"];

      addCart
          .where('Product_ID', isEqualTo: productId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          addCart.doc(doc.id).update({'price': newPrice});
        }
      });
    }
    notifyListeners();
  }

  void incrementCounter() {
    counter++;
    // log(counter.toString());
    notifyListeners();
  }

  void decrementCounter() {
    if (counter > 1) {
      counter--;
    }
    notifyListeners();
  }

  // void addProduct() {
  //   value = cartList.length; // เพิ่มจำนวนสินค้าในตะกร้า
  //   notifyListeners();
  // }

  Future<void> addToCart(
    Map item,
  ) async {
    final productId = item['Product_ID'] as String?;
    if (productId == null) {
      // Handle the case where 'Product_ID' is null
      return;
    }
    final docQuerySnapshot =
        await addCart.where('Product_ID', isEqualTo: productId).get();
    if (docQuerySnapshot.docs.isNotEmpty) {
      // อัพเดทข้อมูล
      final docRef = docQuerySnapshot.docs.first.reference;
      final docSnap = await docRef.get();
      await docRef.update({
        'name': item['name'],
        'pathImg': item['pathImg'],
        'unit': (int.parse(docSnap.get('unit')) + counter).toString(),
        'price': item['price'],
      }).catchError((error) => debugPrint("Failed to update item: $error"));
    } else {
      // เพิ่มข้อมูลใหม่
      final docRef = addCart.doc(
        Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch.toString(),
      );
      await docRef.set({
        'Product_ID': item['Product_ID'],
        'name': item['name'],
        'pathImg': item['pathImg'],
        'unit': counter.toString(),
        'price': item['price'],
      }).catchError((error) => debugPrint("Failed to add item: $error"));
    }
    final cartItems = await addCart.get();
    cartList = cartItems.docs.map((doc) => doc.data()).toList();

    // log(cartList.toString());
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    try {
      final querySnapshot =
          await addCart.where("Product_ID", isEqualTo: productId).get();
      final batch = FirebaseFirestore.instance.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      cartList.removeWhere((item) => item['Product_ID'] == productId);
    } catch (error) {
      debugPrint("Failed to remove item: $error");
    }
    // log(cartList.toString());

    notifyListeners();
  }

  Future<void> unitincrementCounter(
    Map item,
  ) async {
    final productId = item['Product_ID'] as String?;
    if (productId == null) {
      return;
    }

    final querySnapshot =
        await addCart.where('Product_ID', isEqualTo: productId).get();
    if (querySnapshot.size != 1) {
      // Handle the case where there are multiple documents with the same productId or no documents
      return;
    }

    final docRef = querySnapshot.docs.first.reference;
    final docSnap = await docRef.get();
    int cartunit = int.parse(docSnap.get('unit'));
    cartunit++;

    await docRef.update({
      'name': item['name'],
      'pathImg': item['pathImg'],
      'unit': cartunit.toString(),
      'price': item['price'],
    }).catchError((error) => debugPrint("Failed to update item: $error"));
    final cartItems = await addCart.get();
    cartList = cartItems.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  Future<void> unitdecrementCounter(Map item) async {
    final productId = item['Product_ID'] as String?;
    if (productId == null) {
      return;
    }

    final querySnapshot =
        await addCart.where('Product_ID', isEqualTo: productId).get();
    if (querySnapshot.size != 1) {
      // Handle the case where there are multiple documents with the same productId or no documents
      return;
    }

    final docRef = querySnapshot.docs.first.reference;
    final docSnap = await docRef.get();
    int cartunit = int.parse(docSnap.get('unit'));

    if (cartunit > 1) {
      cartunit--;
    }

    await docRef.update({
      'name': item['name'],
      'pathImg': item['pathImg'],
      'unit': cartunit.toString(),
      'price': item['price'],
    }).catchError((error) => debugPrint("Failed to update item: $error"));

    final cartItems = await addCart.get();
    cartList = cartItems.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  void clearListCartProduct() {
    log('cartList.toString()');
    log(cartList.toString());
    cartList.clear();
    log(cartList.toString());
  }
}
