import 'package:flutter/material.dart';
import '../../shared/action_button.dart';

class CheckoutFooter extends StatelessWidget {
  final double subtotal;
  final double total;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool? isProcessing;
  final bool? hasDelivery;

  const CheckoutFooter({
    super.key,
    required this.subtotal,
    required this.total,
    required this.buttonLabel,
    this.onPressed,
    this.isProcessing,
    this.hasDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '€${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (hasDelivery == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Delivery',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '€5.00',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (hasDelivery == true) const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(
                    '€${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ActionButton(
                label: buttonLabel,
                onPressed: isProcessing == true ? null : onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
