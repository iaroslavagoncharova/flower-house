import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/pages/checkout_page.dart';
import 'package:flutter_flower_shop/pages/confirmation_page.dart';
import 'package:flutter_flower_shop/pages/home_page.dart';
import 'package:flutter_flower_shop/pages/intro_page.dart';
import 'package:flutter_flower_shop/pages/product_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flower_shop/services/database.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService().getProductsStream(),
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/intro',
        routes: {
          '/intro': (context) => const IntroPage(),
          '/home': (context) => const HomePage(),
          '/product': (context) => const ProductPage(),
          '/checkout': (context) => const CheckoutPage(),
          '/confirmation': (context) => const ConfirmationPage(),
        },
      ),
    );
  }
}
