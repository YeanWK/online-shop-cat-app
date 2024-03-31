import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/detail_page/detail.dart';
import 'pages/home_page/homepage.dart';
import 'pages/provider/address_provider.dart';
import 'pages/provider/banner_provider.dart';
import 'pages/provider/cart_provider.dart';
import 'pages/provider/catagory_provider.dart';
import 'pages/provider/favourite_provider.dart';
import 'pages/provider/logo_provider.dart';
import 'pages/provider/news_provider.dart';
import 'pages/provider/product_provider.dart';
import 'pages/provider/profilecat_provider.dart';
import 'pages/provider/user_provider.dart';
import 'pages/welcome_page/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider()),
        ChangeNotifierProvider<SlProvider>(create: (context) => SlProvider()),
        ChangeNotifierProvider<ProductProvider>(
            create: (context) => ProductProvider()),
        ChangeNotifierProvider<CatagoryProvider>(
            create: (context) => CatagoryProvider()),
        ChangeNotifierProvider<NewsProvider>(
            create: (context) => NewsProvider()),
        ChangeNotifierProvider<FavouriteProductProvider>(
            create: (context) => FavouriteProductProvider()),
        ChangeNotifierProvider<LogoProvider>(
            create: (context) => LogoProvider()),
        ChangeNotifierProvider<AddressProvider>(
            create: (context) => AddressProvider()),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<CatProvider>(create: (context) => CatProvider()),
      ],
      child: MaterialApp(
          routes: {
            '/detail_product': (context) => const DetailProduct(item: {}),
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Kanit',
            scaffoldBackgroundColor: Colors.white,
          ),

          // home: const AuthScreen(),
          // home: const Login2(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // log(snapshot.toString());
              if (snapshot.hasData) {
                log(FirebaseAuth.instance.authStateChanges().toString());

                return const HomePage();
              } else {
                log("donthave");
                log(FirebaseAuth.instance.authStateChanges().toString());
                return const Welcome();
              }
            },
          )
          // home: const MainPage(),
          // home: const LoginPage(),
          // home: const LoginScreen(),

          // home: const HomePage(),
          // home: const Chat(),
          // home: const HomeChat(),
          // home: const ProductDetails(),
          // home: const DataFirebase(),
          ),
    );
  }
}
