import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/data/models/product.dart';

enum ProductImageVariant { mobile, web }

class ProductImage extends StatelessWidget {
  final Product product;
  final ProductImageVariant variant;

  const ProductImage({
    super.key,
    required this.product,
    this.variant = ProductImageVariant.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = variant == ProductImageVariant.web ? 24.0 : 16.0;

    final aspectRatio = variant == ProductImageVariant.web ? 3 / 4 : 4 / 3;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedNetworkImage(
          imageUrl: product.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
