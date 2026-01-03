import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_flower_shop/data/models/product.dart';
import 'package:flutter_flower_shop/data/services/database.dart';
import 'package:provider/provider.dart';
import 'widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productsSnapshot = Provider.of<QuerySnapshot?>(context);

    if (productsSnapshot == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final products = productsSnapshot.docs
        .map(
          (doc) =>
              Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();

    final width = MediaQuery.of(context).size.width;
    final isWeb = width >= 1000;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService().getProductsStream(),
      initialData: null,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? width * 0.1 : 16,
            vertical: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: isWeb
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isWeb
                          ? 500
                          : MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: SearchAnchor(
                      builder:
                          (BuildContext context, SearchController controller) {
                            return SearchBar(
                              controller: controller,
                              padding: const WidgetStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              onTap: () {
                                controller.openView();
                              },
                              onChanged: (_) {
                                controller.openView();
                              },
                              leading: const Icon(Icons.search),
                            );
                          },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                            return [];
                          },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 16),
              _buildCategoriesRow(),
              const SizedBox(height: 24),
              const Text(
                'Birthday',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildProductGrid(isWeb, isLandscape, products),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesRow() {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: DatabaseService().getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No categories found');
        }

        final categories = snapshot.data!;

        return SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final cat = categories[index];

              return Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary,
                    backgroundImage: AssetImage(cat['imageUrl']),
                  ),
                  const SizedBox(height: 8),
                  Text(cat['name'], style: const TextStyle(fontSize: 14)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(
    bool isWeb,
    bool isLandscape,
    List<Product> products,
  ) {
    final crossAxisCount = isWeb || isLandscape ? 4 : 2;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
