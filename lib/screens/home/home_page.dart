import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_flower_shop/data/models/product.dart';
import 'package:flutter_flower_shop/data/services/database.dart';
import 'package:flutter_flower_shop/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategoryId = 'all';
  String _selectedCategoryName = 'All';
  String _selectedCategoryDescription = 'Browse all products';
  List<Product> _filteredProducts = [];
  List<Product> _allProducts = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  final _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
    _loadCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.value.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _allProducts;
      });
    } else {
      setState(() {
        _filteredProducts = _allProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  Future<void> _loadAllProducts() async {
    final productsSnapshot = await DatabaseService().getAllProducts();
    final products = productsSnapshot.docs
        .map(
          (doc) =>
              Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();

    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _isLoading = false;
    });

    await Future.wait(
      _allProducts
          .where((p) => p.imageUrl.isNotEmpty)
          .map(
            (p) =>
                precacheImage(CachedNetworkImageProvider(p.imageUrl), context),
          ),
    );
  }

  Future<void> _loadCategories() async {
    final categoriesSnapshot = await DatabaseService().getAllCategories();
    final categories = categoriesSnapshot
        .map(
          (doc) => {
            'id': doc.id,
            'name': doc['name'],
            'description': doc['description'],
            'imageUrl': doc['imageUrl'],
          },
        )
        .toList();

    setState(() {
      _categories = categories;
    });

    await Future.wait(
      _categories
          .where((c) => c['imageUrl'] != null && c['imageUrl'].isNotEmpty)
          .map(
            (c) => precacheImage(
              CachedNetworkImageProvider(c['imageUrl']),
              context,
            ),
          ),
    );
  }

  Future<void> _filterProductsByCategory(
    String categoryId,
    String categoryName,
    String categoryDescription,
  ) async {
    if (categoryId == 'all') {
      setState(() {
        _selectedCategoryId = 'all';
        _selectedCategoryName = 'All';
        _selectedCategoryDescription = 'Browse all products';
        _filteredProducts = _allProducts;
      });
    } else {
      final productsSnapshot = await DatabaseService().getProductsByCategory(
        categoryId,
      );
      final products = productsSnapshot.docs
          .map(
            (doc) => Product.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      setState(() {
        _selectedCategoryId = categoryId;
        _selectedCategoryName = categoryName;
        _selectedCategoryDescription = categoryDescription;
        _filteredProducts = products;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width >= 1000;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? width * 0.1 : 16,
                vertical: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isWeb),
                  const SizedBox(height: 16),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoriesRow(),
                  const SizedBox(height: 24),
                  Text(
                    _selectedCategoryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedCategoryDescription.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _selectedCategoryDescription,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  _buildProductGrid(isWeb, isLandscape),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(bool isWeb) {
    final cart = context.watch<CartProvider>();
    return Row(
      mainAxisAlignment: isWeb
          ? MainAxisAlignment.end
          : MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: isWeb ? 500 : MediaQuery.of(context).size.width * 0.7,
          ),
          child: SearchAnchor(
            searchController: _searchController,
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                onTap: () {
                  setState(() {
                    controller.openView();
                  });
                },
                onChanged: (_) {
                  setState(() {
                    controller.openView();
                  });
                },
                autoFocus: false,
                elevation: WidgetStatePropertyAll(2),
                leading: const Icon(Icons.search),
                hintText: 'Search products',
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  final query = controller.value.text.toLowerCase();
                  final suggestions = _allProducts
                      .where((p) => p.name.toLowerCase().contains(query))
                      .toList();

                  return suggestions.map((product) {
                    return ListTile(
                      leading: product.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : const Icon(Icons.local_florist),
                      title: Text(product.name),
                      subtitle: Text('€${product.price.toStringAsFixed(2)}'),
                      onTap: () {
                        setState(() {
                          controller.closeView(product.name);
                        });
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: product,
                        );
                      },
                    );
                  }).toList();
                },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
                ),
                if (cart.totalItems > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          cart.totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesRow() {
    final categoriesWithAll = [
      {
        'id': 'all',
        'name': 'All',
        'description': 'All products',
        'imageUrl': '',
      },
      ..._categories,
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesWithAll.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = categoriesWithAll[index];
          bool isSelected = _selectedCategoryId == cat['id'];

          return GestureDetector(
            onTap: () {
              _filterProductsByCategory(
                cat['id'],
                cat['name'],
                cat['description'],
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: cat['imageUrl'].isNotEmpty
                      ? CachedNetworkImageProvider(cat['imageUrl'])
                      : null,
                ),

                const SizedBox(height: 8),
                Text(
                  cat['name'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? AppColors.primary : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(bool isWeb, bool isLandscape) {
    final crossAxisCount = isWeb || isLandscape ? 4 : 2;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: _filteredProducts[index]);
      },
    );
  }
}
