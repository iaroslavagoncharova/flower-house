import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/data/models/cart_item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_flower_shop/screens/product/widgets/quantity_selector.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  void _openProductDetails(BuildContext context) {
    Navigator.of(context).pushNamed('/product', arguments: item.product);
  }

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return GestureDetector(
      onTap: () => _openProductDetails(context),
      child: Slidable(
        key: ValueKey(product.id),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onRemove(),
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${product.price.toStringAsFixed(2)}€',
                      style: const TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 8),

                    QuantitySelector(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
