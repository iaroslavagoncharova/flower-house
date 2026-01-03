import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  var uuid = Uuid();

  final CollectionReference categoriesCollection = FirebaseFirestore.instance
      .collection('categories');
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');
  final CollectionReference ordersCollection = FirebaseFirestore.instance
      .collection('orders');

  Future<List<QueryDocumentSnapshot>> getAllCategories() async {
    final snapshot = await categoriesCollection.get();
    return snapshot.docs;
  }

  Future<QuerySnapshot> getAllProducts() {
    return productsCollection.get();
  }

  Future<QuerySnapshot> getProductsByCategory(String categoryId) {
    return productsCollection
        .where('categoryIds', arrayContains: categoryId)
        .get();
  }

  Future<DocumentSnapshot> getProductById(String productId) {
    return productsCollection.doc(productId).get();
  }

  Future<void> createOrder({
    required String customerName,
    required String customerEmail,
    required List<Map<String, dynamic>> products,
    required double totalPrice,
  }) async {
    await ordersCollection.add({
      'orderId': uuid.v4().substring(0, 8),
      'customerName': customerName,
      'customerEmail': customerEmail,
      'products': products,
      'totalPrice': totalPrice,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getProductsStream() {
    return productsCollection.snapshots();
  }
}
