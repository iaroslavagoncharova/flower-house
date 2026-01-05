import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/providers/cart_provider.dart';
import 'package:flutter_flower_shop/screens/cart/widgets/cart_item_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_flower_shop/shared/checkout_footer.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cart (${cart.items.length})',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: cart.items.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Your cart is empty!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Add some fresh flowers to brighten your day 🌸",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 16),
                    ...cart.items.map(
                      (item) => CartItemTile(
                        item: item,
                        onRemove: () => cart.remove(item.product),
                        onIncrement: () => cart.increment(item.product),
                        onDecrement: () => cart.decrement(item.product),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: CheckoutFooter(
        subtotal: cart.total,
        total: cart.total,
        buttonLabel: 'Checkout',
        onPressed: cart.items.isEmpty
            ? null
            : () => Navigator.pushNamed(context, '/checkout'),
      ),
    );
  }
}
