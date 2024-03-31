import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Payment/payment_page.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key, required this.item});

  final List item;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0, // กำหนดความสูงของเงา
        shadowColor: Colors.grey, // กำหนดสีของเงา
        iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
        toolbarHeight: 66,
        centerTitle: true,
        title: const Text(
          'รถเข็นของฉัน',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  cartlist(),
                ],
              ),
            ),
          ),
          buttoncart(),
        ],
      ),
    );
  }

  Widget cartlist() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Consumer<CartProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.cartList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        provider
                            .removeItem(provider.cartList[index]['Product_ID']);
                        log(index.toString());
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'ลบ',
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        provider.cartList[index]['pathImg'],
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.cartList[index]['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                provider.cartList[index]['price'],
                                style: TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    child: FloatingActionButton(
                                      heroTag: UniqueKey(),
                                      backgroundColor: Colors.white,
                                      onPressed: () =>
                                          provider.unitdecrementCounter(
                                              provider.cartList[index]),
                                      child: const IconTheme(
                                        data:
                                            IconThemeData(color: Colors.black),
                                        child: Icon(Icons.remove, size: 12),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    provider.cartList[index]['unit'],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: FloatingActionButton(
                                      heroTag: UniqueKey(),
                                      backgroundColor: Colors.white,
                                      onPressed: () =>
                                          provider.unitincrementCounter(
                                              provider.cartList[index]),
                                      child: const IconTheme(
                                        data:
                                            IconThemeData(color: Colors.black),
                                        child: Icon(
                                          Icons.add,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buttoncart() {
    List cartproduct = [];
    List product = [];
    var productProvider = context.read<ProductProvider>();
    var cartProvider = context.read<CartProvider>();
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Shop')
        .collection('Product')
        .snapshots();
    log("firestore");
    log(firestore.toString());
    return Container(
      width: double.infinity,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          const Text(
            "รวมทั้งหมด",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          const Text(
            "\u0E3F",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, provider, _) {
              return Text(
                provider.totalPrice.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              );
            },
          ),
          const Spacer(),
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                final List cartProductIds = context
                    .read<CartProvider>()
                    .cartList
                    .map((item) => item['Product_ID'])
                    .toList();
                final addproduct = snapshot
                    .data!.docs //เอาแค่product ที่อยู่ใน cart
                    .map((DocumentSnapshot document) =>
                        document.data() as Map<String, dynamic>)
                    .where(
                        (item) => cartProductIds.contains(item['Product_ID']))
                    .toList();
                product = addproduct.map((item) {
                  return {
                    'Product_ID': item['Product_ID'],
                    'name': item['name'],
                    'price': item['price'],
                  };
                }).toList();
                log('addproduct');
                log(product.toString());

                return Container();
              } else {
                return const Text('Something went wrong');
              }
            },
          ),
          Container(
            width: 120,
            height: 66,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFFFA500),
                Color(0xFFFF6347),
              ]),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: ElevatedButton(
              onPressed: () {
                cartproduct = cartProvider.cartList.map((item) {
                  return {
                    'Product_ID': item['Product_ID'],
                    'name': item['name'],
                    'price': item['price'],
                  };
                }).toList();
                log('cartproduct');
                log(cartproduct.toString());
                if (product.toString() == cartproduct.toString()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentPage()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('ราคามีการเปลี่ยนแปลง'),
                      content: const Text(
                          'มีการเปลี่ยนแปลงราคาของสินค้าที่คุณเลือก'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            productProvider.updateListProduct(product);
                            cartProvider.updatecartList(product);
                            // cartproduct = product;

                            log('cartproduct.toString()');
                            log(cartproduct.toString());
                            Navigator.pop(context); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF914D),
                          ),
                          child: const Text('ตกลง'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                "ชำระเงิน",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
