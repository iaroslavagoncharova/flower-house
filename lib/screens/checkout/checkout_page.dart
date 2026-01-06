import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_flower_shop/data/services/email_service.dart';
import 'package:flutter_flower_shop/data/services/stripe_service.dart';
import 'package:flutter_flower_shop/providers/cart_provider.dart';
import 'package:flutter_flower_shop/screens/checkout/widgets/checkout_cart_summary.dart';
import 'package:flutter_flower_shop/screens/checkout/widgets/checkout_delivery_toggle.dart';
import 'package:flutter_flower_shop/screens/checkout/widgets/checkout_user_form.dart';
import 'package:flutter_flower_shop/shared/checkout_footer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_flower_shop/screens/checkout/widgets/checkout_map.dart';
import 'package:flutter_flower_shop/data/models/order.dart';
import 'package:flutter_flower_shop/data/services/order_service.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formScrollController = ScrollController();

  bool _isDelivery = true;
  final double _deliveryCost = 5.0;

  bool _addressConfirmed = false;
  bool _isPaying = false;

  LatLng _mapCenter = LatLng(60.1683639, 24.9325021);
  late Marker _marker;

  late final MapController _mapController;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _marker = Marker(
      width: 80,
      height: 80,
      point: _mapCenter,
      child: const Icon(Icons.location_on, color: AppColors.primary, size: 40),
    );

    _addressController.addListener(() {
      if (_isDelivery) _updateMapFromAddress(_addressController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateMapFromAddress(String address) async {
    if (address.isEmpty) return;

    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        setState(() {
          _mapCenter = LatLng(loc.latitude, loc.longitude);
          _marker = Marker(
            width: 80,
            height: 80,
            point: _mapCenter,
            child: const Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 40,
            ),
          );

          _mapController.move(_mapCenter, 15);
        });
      }
    } catch (e) {
      throw Exception('Failed to update map from address: $e');
    }
  }

  Future<void> _handlePayment(CartProvider cart, double total) async {
    if (_isPaying) return;

    setState(() => _isPaying = true);

    try {
      final result = await StripeService.pay(amount: total, context: context);

      if (result == PaymentResult.cancelled || result == PaymentResult.failed) {
        return;
      }

      final order = UserOrder(
        id: Uuid().v4().substring(0, 8),
        items: cart.items,
        subtotal: cart.total,
        deliveryCost: _isDelivery ? _deliveryCost : 0,
        total: total,
        isDelivery: _isDelivery,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _isDelivery ? _addressController.text : null,
        location: _isDelivery
            ? GeoPoint(_mapCenter.latitude, _mapCenter.longitude)
            : null,
        createdAt: DateTime.now(),
      );

      await OrderService.createOrder(order);

      if (!mounted) return;
      await sendOrderConfirmationEmail(order);
      cart.clear();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/confirmation',
        (route) => false,
        arguments: order,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      if (mounted) {
        setState(() => _isPaying = false);
      }
    }
  }

  bool _validateBeforePay(CartProvider cart) {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return false;
    }

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );

      _formScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
      return false;
    }

    if (_isDelivery && !_addressConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid delivery address from the list'),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final subtotal = cart.total;
    final total = _isDelivery ? subtotal + _deliveryCost : subtotal;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      controller: _formScrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        CheckoutCartSummary(items: cart.items),
                        const SizedBox(height: 24),
                        CheckoutUserForm(
                          nameController: _nameController,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          addressController: _addressController,
                          isDelivery: _isDelivery,
                          onAddressChanged: () {
                            setState(() => _addressConfirmed = false);
                          },
                          onAddressSelected: (suggestion) {
                            setState(() {
                              _addressConfirmed = true;
                              _mapCenter = suggestion.location;
                              _marker = Marker(
                                width: 80,
                                height: 80,
                                point: _mapCenter,
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                              );

                              _mapController.move(_mapCenter, 15);
                            });
                          },
                        ),

                        const SizedBox(height: 24),
                        CheckoutDeliveryToggle(
                          isDelivery: _isDelivery,
                          onChanged: (val) {
                            setState(() {
                              _isDelivery = val;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _isDelivery
                            ? const Text(
                                'Your order will be delivered to the address above. Our driver will contact you by phone if needed.',
                                style: TextStyle(fontSize: 16),
                              )
                            : const Text(
                                'You can collect your order from our store in Kamppi once you receive the confirmation email.',
                                style: TextStyle(fontSize: 16),
                              ),
                        const SizedBox(height: 24),
                        CheckoutMap(
                          mapCenter: _mapCenter,
                          mapController: _mapController,
                          marker: _marker,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                CheckoutFooter(
                  subtotal: subtotal,
                  total: total,
                  buttonLabel: _isPaying
                      ? 'Processing…'
                      : 'Pay ${total.toStringAsFixed(2)}€',
                  isProcessing: _isPaying,
                  onPressed: _isPaying
                      ? null
                      : () {
                          if (_validateBeforePay(cart)) {
                            _handlePayment(cart, total);
                          }
                        },
                  hasDelivery: _isDelivery,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
