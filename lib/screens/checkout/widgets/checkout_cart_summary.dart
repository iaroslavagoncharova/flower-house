import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/data/models/cart_item.dart';
import 'package:flutter_flower_shop/screens/checkout/widgets/checkout_cart_item.dart';

class CheckoutCartSummary extends StatelessWidget {
  final List<CartItem> items;

  const CheckoutCartSummary({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => CheckoutCartItem(item: item)),
        Divider(color: Colors.grey[300]),
      ],
    );
  }
}
