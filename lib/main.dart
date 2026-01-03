import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/screens/checkout/checkout_page.dart';
import 'package:flutter_flower_shop/screens/confirmation/confirmation_page.dart';
import 'package:flutter_flower_shop/screens/home/home_page.dart';
import 'package:flutter_flower_shop/screens/intro/intro_page.dart';
import 'package:flutter_flower_shop/screens/product/product_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flower_shop/data/services/database.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_flower_shop/core/theme/app_theme.dart';

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
        theme: AppTheme.light(),
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
