import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../detail_page/detail.dart';
import '../provider/address_provider.dart';
import '../provider/banner_provider.dart';
import '../provider/catagory_provider.dart';
import '../provider/product_provider.dart';
import '../provider/profilecat_provider.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2();
}

class _HomePage2 extends State<HomePage2> {
  double height = 0;
  double width = 0;
  int activePage = 1;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.8, initialPage: 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                homebody(),
                // callAddress(),
                // catagory(context),
                // textproduct(),
                // listProduct(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget callAddress() {
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Users')
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc('Addresses')
        .collection('addresses')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final addressdata = snapshot.data!.docs
            .map((DocumentSnapshot document) =>
                document.data() as Map<String, dynamic>)
            .toList();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AddressProvider>().addAddressData(addressdata);
        });

        return Container();
      },
    );
  }

  Widget callCat() {
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Users')
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc('ProfileCat')
        .collection('ProfileCat')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final catdata = snapshot.data!.docs
            .map((DocumentSnapshot document) =>
                document.data() as Map<String, dynamic>)
            .toList();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<CatProvider>().addCatData(catdata);
        });

        return Container();
      },
    );
  }

  Widget listProduct(BuildContext context) {
    log('listProduct');
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Shop')
        .collection('Product')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final product = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();

          context.read<ProductProvider>().addListProduct(product);

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: product.length, // number of items in the GridView
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
                        builder: (context) => DetailProduct(
                              item: product[index],
                            )),
                  );
                },
                child: itemproduct(
                  product[index]["pathImg"],
                  product[index]["name"],
                  product[index]["price"],
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

  Widget catagory(BuildContext contex) {
    log("catagory");
    var size = MediaQuery.of(context).size;
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Shop')
        .collection('IconCatagory')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final catagoryicon = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();
          context.read<CatagoryProvider>().addCatagory(catagoryicon);
          return SizedBox(
            height: size.height * 0.15,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: catagoryicon.length, // จำนวนของ item ใน GridView
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 1, // จำนวนของแถว
                childAspectRatio:
                    1.3, // อัตราส่วนของขนาดของแต่ละ Widget ใน GridView   0.6, // aspect ratio of each widget in the GridView
              ),
              itemBuilder: (BuildContext context, int index) {
                return itemcat(catagoryicon[index]["pathImg"],
                    catagoryicon[index]["name"]);
              },
            ),
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }

  Widget banner(BuildContext context) {
    log('banner');
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Shop')
        .collection('Banner')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final bannershow = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();
          context.read<SlProvider>().addBannerShow(bannershow);
          return CarouselSlider(
            items: bannershow.map((item) {
              return Image.network(item['images']);
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
            ),
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }

  Widget itemcat(String img, String title) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
          height: size.height * 0.12,
          width: size.width * 0.32,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(flex: 1, child: Image.network(img)),
              Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ))
            ],
          )),
    );
  }

  Widget itemproduct(String img, String name, String price) {
    return Container(
        // color: Colors.red,
        // height: 100,
        // width: 100,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: Image.network(
                  img,
                  height: 500,
                )),
            Expanded(
                flex: 1,
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                )),
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
                )),
          ],
        ));
  }

  Widget homebody() {
    var size = MediaQuery.of(context).size;
    var slProvider = context.read<SlProvider>();
    var catagoryProvider = context.read<CatagoryProvider>();
    var productProvider = context.read<ProductProvider>();
    var addressProvider = context.read<AddressProvider>();
    var catProvider = context.read<CatProvider>();

    return Column(
      children: [
        const SizedBox(height: 30),
        slProvider.bannershow.isEmpty
            ? banner(context)
            : CarouselSlider(
                items: slProvider.bannershow.map((item) {
                  return Image.network(item['images']);
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                ),
              ),
        Container(
          padding: const EdgeInsets.only(left: 26),
          alignment: Alignment.centerLeft,
          child: const Text(
            'หมวดหมู่',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        catagoryProvider.catagoryicon.isEmpty
            ? catagory(context)
            : SizedBox(
                height: size.height * 0.15,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: catagoryProvider
                      .catagoryicon.length, // จำนวนของ item ใน GridView
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    crossAxisCount: 1, // จำนวนของแถว
                    childAspectRatio:
                        1.3, // อัตราส่วนของขนาดของแต่ละ Widget ใน GridView   0.6, // aspect ratio of each widget in the GridView
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return itemcat(
                        catagoryProvider.catagoryicon[index]["pathImg"],
                        catagoryProvider.catagoryicon[index]["name"]);
                  },
                ),
              ),
        Container(
          padding: const EdgeInsets.only(left: 26),
          alignment: Alignment.centerLeft,
          child: const Text(
            "สินค้าแนะนำ",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        productProvider.product.isEmpty
            ? listProduct(context)
            : Consumer(builder: (BuildContext context,
                ProductProvider productProvider, Widget? child) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productProvider
                      .product.length, // number of items in the GridView
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
                        log("addresssssssssssssssssssssssssssssssssss");
                        log(addressProvider.addressdata.toString());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailProduct(
                                    item: productProvider.product[index],
                                  )),
                        );
                      },
                      child: itemproduct(
                        productProvider.product[index]["pathImg"],
                        productProvider.product[index]["name"],
                        productProvider.product[index]["price"],
                      ),
                    );
                  },
                );
              }),
        addressProvider.addressdata.isEmpty ? callAddress() : Container(),
        catProvider.catdata.isEmpty ? callCat() : Container()
      ],
    );
  }
}
