import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_flower_shop/data/models/product.dart';
import 'package:flutter_flower_shop/data/services/database.dart';
import 'widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategoryId = 'all';
  String _selectedCategoryName = 'All';
  String _selectedCategoryDescription = '';
  List<Product> _filteredProducts = [];
  List<Product> _allProducts = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
    _loadCategories();
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
                vertical: 32,
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
                  const SizedBox(height: 16),
                  _buildProductGrid(isWeb, isLandscape),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(bool isWeb) {
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
            builder: (BuildContext context, SearchController controller) {
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
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
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
                  backgroundColor: AppColors.primary,
                  backgroundImage: cat['imageUrl'].isEmpty
                      ? null
                      : AssetImage(cat['imageUrl']),
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
