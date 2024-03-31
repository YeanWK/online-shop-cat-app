import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../detail_page/detail.dart';
import '../provider/favourite_provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePage();
}

class _FavouritePage extends State<FavouritePage> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var productProvider = context.read<FavouriteProductProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 4.0, // กำหนดความสูงของเงา
          shadowColor: Colors.grey, // กำหนดสีของเงา
          iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
          toolbarHeight: 66,
          centerTitle: true,
          title: const Text(
            'สินค้าที่สนใจ',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              productProvider.product.isEmpty
                  ? favouriteList(context)
                  : Consumer(
                      builder: (BuildContext context,
                          FavouriteProductProvider value, Widget? child) {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: value.product
                              .length, // number of items in the GridView
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            crossAxisCount: 2, // number of rows
                            childAspectRatio:
                                0.6, // aspect ratio of each widget in the GridView
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailProduct(
                                        item: value.product[index]),
                                  ),
                                );
                              },
                              child: itemproduct(
                                value.product[index]["pathImg"],
                                value.product[index]["name"],
                                value.product[index]["price"],
                                value.product[index]["Product_ID"],
                              ),
                            );
                          },
                        );
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget favouriteList(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('MeowMeowCat')
          .doc('Users')
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc('Favourite')
          .collection('items')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final favproduct = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();

          context.read<FavouriteProductProvider>().addListProduct(favproduct);
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: favproduct.length, // number of items in the GridView
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2, // number of rows
              childAspectRatio:
                  0.6, // aspect ratio of each widget in the GridView
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailProduct(item: favproduct[index]),
                    ),
                  );
                },
                child: itemproduct(
                  favproduct[index]["pathImg"],
                  favproduct[index]["name"],
                  favproduct[index]["price"],
                  favproduct[index]["Product_ID"],
                ),
              );
            },
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }

  Widget itemproduct(String img, String name, String price, String id) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Image.network(
                  img,
                  height: 500,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "\u0E3F",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<FavouriteProductProvider>(context, listen: false)
                  .removeToFavourite(id);
            },
          ),
        ),
      ],
    );
  }
}
