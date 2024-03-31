import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../pages/cart_page/cart.dart';
import '../pages/provider/cart_provider.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    var cartprovider = context.read<CartProvider>();
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "MEOW MEOW CAT",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      centerTitle: true,

      actions: [
        cartprovider.cartList.isEmpty
            ? cartlist(context)
            : Consumer(
                builder:
                    (BuildContext context, CartProvider value, Widget? child) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cart(
                                      item: value.cartList,
                                    )),
                          );
                        },
                        icon: badges.Badge(
                          position: BadgePosition.topEnd(),
                          badgeContent: Text(value.cartList.length.toString()),
                          child: const Icon(
                            Icons.shopping_cart,
                            size: 30,
                          ),
                        )),
                  );
                },
              )
      ],
      elevation: 4.0, // กำหนดความสูงของเงา
      shadowColor: Colors.grey, // กำหนดสีของเงา
    );
  }

  Widget cartlist(BuildContext context) {
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Users')
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc('Cart')
        .collection('items')
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
          final cart = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();

          context.read<CartProvider>().addcartList(cart);

          return Consumer(
            builder: (BuildContext context, CartProvider value, Widget? child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cart(
                                  item: value.cartList,
                                )),
                      );
                    },
                    icon: badges.Badge(
                      position: BadgePosition.topEnd(),
                      badgeContent: Text(value.cartList.length.toString()),
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 30,
                      ),
                    )),
              );
            },
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
