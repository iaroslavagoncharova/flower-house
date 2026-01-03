class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String summary;
  final String description;
  final List<String> categoryIds;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.summary,
    required this.description,
    required this.categoryIds,
  });

  factory Product.fromFirestore(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'],
      summary: data['summary'],
      description: data['description'],
      categoryIds: List<String>.from(data['categoryIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'summary': summary,
      'description': description,
      'categoryIds': categoryIds,
    };
  }
}
