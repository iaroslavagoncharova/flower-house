import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/shared/circle_icon_button.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleIconButton(icon: Icons.remove, onPressed: onDecrement),
          const SizedBox(width: 12),
          Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          CircleIconButton(icon: Icons.add, onPressed: onIncrement),
        ],
      ),
    );
  }
}
