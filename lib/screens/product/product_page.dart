import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_flower_shop/core/theme/app_text_styles.dart';
import 'package:flutter_flower_shop/data/models/product.dart';
import 'package:flutter_flower_shop/screens/product/widgets/quantity_selector.dart';
import 'package:flutter_flower_shop/shared/action_button.dart';
import 'widgets/product_image.dart';
import 'widgets/product_details_row.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() => quantity++);
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null || route.settings.arguments is! Product) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    final product = route.settings.arguments as Product;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWeb = constraints.maxWidth >= 1000;

            if (!isWeb) {
              return _buildMobileBody(constraints, product);
            }

            return Center(
              child: SizedBox(
                width: constraints.maxWidth * 0.8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ProductImage(
                          product: product,
                          variant: ProductImageVariant.web,
                        ),
                      ),

                      const SizedBox(width: 48),

                      Expanded(
                        flex: 4,
                        child: _buildWebDetailsWithActions(product),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: MediaQuery.of(context).size.width >= 1000
          ? null
          : _mobileBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        style: IconButton.styleFrom(backgroundColor: Colors.white),
        padding: const EdgeInsets.all(8),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildMobileBody(BoxConstraints constraints, Product product) {
    final isWide = constraints.maxWidth >= 620;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: ProductImage(product: product)),
                      const SizedBox(width: 24),
                      Expanded(flex: 6, child: _buildDetails(product)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImage(product: product),
                      const SizedBox(height: 16),
                      _buildDetails(product),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebDetailsWithActions(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetails(product),

        const SizedBox(height: 32),

        Row(
          children: [
            QuantitySelector(
              quantity: quantity,
              onDecrement: _decrementQuantity,
              onIncrement: _incrementQuantity,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ActionButton(onPressed: () {}, label: "Add to cart"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetails(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailsRow(product: product),

        const SizedBox(height: 8),

        Text(product.summary, style: AppTextStyles.summary),

        const SizedBox(height: 24),
        Divider(color: AppColors.divider),
        const SizedBox(height: 16),

        Text(product.description, style: AppTextStyles.body),
      ],
    );
  }

  Widget _mobileBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: QuantitySelector(
                quantity: quantity,
                onDecrement: _decrementQuantity,
                onIncrement: _incrementQuantity,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 56,
                child: ActionButton(onPressed: () {}, label: "Add to cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
