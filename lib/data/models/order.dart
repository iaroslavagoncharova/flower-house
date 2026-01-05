import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class UserOrder {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryCost;
  final double total;
  final bool isDelivery;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final GeoPoint? location;
  final DateTime createdAt;

  UserOrder({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryCost,
    required this.total,
    required this.isDelivery,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryCost': deliveryCost,
      'total': total,
      'isDelivery': isDelivery,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
