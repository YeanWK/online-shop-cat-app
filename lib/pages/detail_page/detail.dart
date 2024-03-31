import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/body_head.dart';
import '../Payment/payment_page.dart';
import '../provider/cart_provider.dart';
import '../provider/favourite_provider.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({
    super.key,
    required this.item,
  });
  final Map item;
  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  Widget build(BuildContext context) {
// padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    return WillPopScope(
      onWillPop: () async {
        context.read<CartProvider>().counter = 1;
        return true;
      },
      child: Scaffold(
        appBar: const MyAppbar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [bodyDetail()],
                  )),
            ),
            bottom()
          ],
        ),
      ),
    );
  }

  Widget bodyDetail() {
    var cartprovider = context.read<CartProvider>();
    return Column(
      children: [
        Container(
          // color: Colors.red,
          child: SizedBox(
            height: 360,
            child: Image.network(
              widget.item['pathImg'],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.item['name'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '\u0E3F',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.item['price'],
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor: Colors.white,
                      onPressed: () => cartprovider.decrementCounter(),
                      child: const IconTheme(
                        data: IconThemeData(color: Colors.black),
                        child: Icon(Icons.remove, size: 12),
                      ),
                    ),
                  ),
                  Consumer(builder: (context, CartProvider value, child) {
                    return Text(
                      '${value.counter}',
                      style: const TextStyle(fontSize: 18),
                    );
                  }),
                  SizedBox(
                    height: 30,
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      backgroundColor: Colors.white,
                      onPressed: () => cartprovider.incrementCounter(),
                      child: const IconTheme(
                        data: IconThemeData(color: Colors.black),
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
        ),
        const Text(
          "รายละเอียดสินค้า",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
          child: Text(
            widget.item['detail'].replaceAll('\\n', '\n'),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget bottom() {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('MeowMeowCat')
                  .doc('Users')
                  .collection(
                      FirebaseAuth.instance.currentUser!.email.toString())
                  .doc('Favourite')
                  .collection('items')
                  .where("Product_ID", isEqualTo: widget.item['Product_ID'])
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Text("");
                }
                return IconButton(
                  onPressed: () => snapshot.data.docs.length == 0
                      // ? debugPrint(snapshot.data.docs.length.toString())
                      ? Provider.of<FavouriteProductProvider>(context,
                              listen: false)
                          .addToFavourite(widget.item)
                      : Provider.of<FavouriteProductProvider>(context,
                              listen: false)
                          .removeToFavourite(widget.item['Product_ID']),
                  icon: snapshot.data.docs.length == 0
                      ? const Icon(
                          Icons.favorite_outline,
                          // color: Colors.white,
                          size: 30,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 30,
                        ),
                );
                // onPressed: () {
                // Provider.of<FavouriteProductProvider>(context,
                //         listen: false)
                //     .addToFavourite(widget.item);
                // },
              }),
          Container(
            height: 46,
            width: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF4DB6AC)]),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(widget.item);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                "เพิ่มลงรถเข็น",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: 46,
            width: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFFFA500),
                Color(0xFFFF6347),
              ]),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                "ซื้อเลย",
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
