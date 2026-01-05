import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/order.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> sendOrderConfirmationEmail(UserOrder order) async {
  final baseUrl = dotenv.env['SERVER_BASE_URL']!;
  final url = Uri.parse('$baseUrl/send-order-email');

  final orderDetails = {
    'orderId': order.id,
    'customerEmail': order.email,
    'customerName': order.name,
    'orderSummary': order.items.map((item) {
      return {
        'name': item.product.name,
        'quantity': item.quantity,
        'price': item.totalPrice,
      };
    }).toList(),
    'total': order.total,
    'isDelivery': order.isDelivery,
    'deliveryAddress': order.isDelivery ? order.address : null,
  };

  await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(orderDetails),
  );
}
