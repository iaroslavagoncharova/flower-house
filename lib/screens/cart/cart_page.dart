import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/data/models/product.dart';
import 'package:flutter_flower_shop/screens/cart/widgets/cart_item_tile.dart';
import 'package:flutter_flower_shop/shared/action_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Product> cartItems = [
    Product(
      id: '1',
      name: 'Rose Bouquet',
      summary: "A beautiful bouquet of red roses.",
      imageUrl: 'https://flutter-flower-house.web.app/images/rose-bouquet.jpg',
      price: 29.99,
      description:
          'A beautiful bouquet of red roses, perfect for any occasion.',
      categoryIds: ["events"],
    ),
    Product(
      id: '2',
      name: 'Tulip Arrangement',
      summary: "A vibrant arrangement of tulips.",
      imageUrl:
          'https://flutter-flower-house.web.app/images/tulip-arrangement.jpg',
      price: 24.99,
      description: 'A vibrant arrangement of tulips to brighten up your day.',
      categoryIds: ["events"],
    ),
    Product(
      id: '3',
      name: 'Rose Bouquet',
      summary: "A beautiful bouquet of red roses.",
      imageUrl: 'https://flutter-flower-house.web.app/images/rose-bouquet.jpg',
      price: 29.99,
      description:
          'A beautiful bouquet of red roses, perfect for any occasion.',
      categoryIds: ["events"],
    ),
    Product(
      id: '4',
      name: 'Tulip Arrangement',
      summary: "A vibrant arrangement of tulips.",
      imageUrl:
          'https://flutter-flower-house.web.app/images/tulip-arrangement.jpg',
      price: 24.99,
      description: 'A vibrant arrangement of tulips to brighten up your day.',
      categoryIds: ["events"],
    ),
    Product(
      id: '5',
      name: 'Rose Bouquet',
      summary: "A beautiful bouquet of red roses.",
      imageUrl: 'https://flutter-flower-house.web.app/images/rose-bouquet.jpg',
      price: 29.99,
      description:
          'A beautiful bouquet of red roses, perfect for any occasion.',
      categoryIds: ["events"],
    ),
    Product(
      id: '6',
      name: 'Tulip Arrangement',
      summary: "A vibrant arrangement of tulips.",
      imageUrl:
          'https://flutter-flower-house.web.app/images/tulip-arrangement.jpg',
      price: 24.99,
      description: 'A vibrant arrangement of tulips to brighten up your day.',
      categoryIds: ["events"],
    ),
  ];

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  double get total => cartItems.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          padding: const EdgeInsets.all(8),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 16),

                Text(
                  'Cart (${cartItems.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...cartItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;

                  return CartItemTile(
                    product: product,
                    onRemove: () => _removeItem(index),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ActionButton(onPressed: () {}, label: "Checkout"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
