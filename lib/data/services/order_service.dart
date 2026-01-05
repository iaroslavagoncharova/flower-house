import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart';

class OrderService {
  static final _orders =
      FirebaseFirestore.instance.collection('orders');

  static Future<void> createOrder(UserOrder order) async {
    await _orders.add(order.toMap());
  }
}
