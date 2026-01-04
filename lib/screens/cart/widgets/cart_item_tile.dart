import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/data/models/product.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_flower_shop/screens/product/widgets/quantity_selector.dart';

class CartItemTile extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.product,
    required this.onRemove,
  });

  void _openProductDetails(BuildContext context, Product product) {
    Navigator.of(context).pushNamed('/product', arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openProductDetails(context, product),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "lib/assets/images/best-mom.jpg",
                    fit: BoxFit.cover,
                  ),
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
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    QuantitySelector(
                      quantity: 1,
                      onIncrement: () {},
                      onDecrement: () {},
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: onRemove,
                      ),
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
