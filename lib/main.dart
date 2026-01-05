import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/screens/cart/cart_page.dart';
import 'package:flutter_flower_shop/screens/checkout/checkout_page.dart';
import 'package:flutter_flower_shop/screens/confirmation/confirmation_page.dart';
import 'package:flutter_flower_shop/screens/home/home_page.dart';
import 'package:flutter_flower_shop/screens/intro/intro_page.dart';
import 'package:flutter_flower_shop/screens/product/product_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flower_shop/data/services/database.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_flower_shop/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flower_shop/providers/cart_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey = dotenv.env['stripePublishableKey']!;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<QuerySnapshot?>.value(
          value: DatabaseService().getProductsStream(),
          initialData: null,
        ),

        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/intro',
        theme: AppTheme.light(),
        routes: {
          '/intro': (context) => const IntroPage(),
          '/home': (context) => const HomePage(),
          '/product': (context) => const ProductPage(),
          '/cart': (context) => const CartPage(),
          '/checkout': (context) => const CheckoutPage(),
          '/confirmation': (context) => const ConfirmationPage(),
        },
      ),
    );
  }
}
