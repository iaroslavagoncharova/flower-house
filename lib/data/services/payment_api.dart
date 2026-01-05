import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentApi {
  static final baseUrl = dotenv.env['SERVER_BASE_URL']!;

  static Future<Map<String, dynamic>> createPaymentSheet({
    required int amount,
    required String currency,
  }) async {
    final url = Uri.parse('$baseUrl/create-payment-sheet');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount, 'currency': currency}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment sheet: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}
