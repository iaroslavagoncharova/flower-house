import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_text_styles.dart';
import 'package:flutter_flower_shop/data/models/product.dart';

class ProductDetailsRow extends StatelessWidget {
  final Product product;

  const ProductDetailsRow({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(product.name, style: AppTextStyles.title)),
        Text(
          '€${product.price.toStringAsFixed(2)}',
          style: AppTextStyles.price,
        ),
      ],
    );
  }
}
