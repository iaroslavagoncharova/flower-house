import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_flower_shop/data/models/order.dart';
import 'dart:math';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final int _numPetals = 10;
  late List<_Petal> _petals;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _petals = List.generate(_numPetals, (_) => _createPetal());
  }

  _Petal _createPetal() {
    return _Petal(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      speed: 0.002 + _random.nextDouble() * 0.003,
      size: 16 + _random.nextDouble() * 12,
      rotation: _random.nextDouble() * 2 * pi,
      rotationSpeed: 0.01 + _random.nextDouble() * 0.02,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as UserOrder;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          for (var petal in _petals) {
            petal.y += petal.speed;
            petal.rotation += petal.rotationSpeed;

            if (petal.y > 1) {
              petal.y = 0;
              petal.x = _random.nextDouble();
            }
          }

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Thank you for your order!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your flowers are on their way 🌸',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Your order has been placed successfully. Please check your email ${order.email} for the receipt.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ..._petals.map((petal) {
                final screenWidth = MediaQuery.of(context).size.width;
                final screenHeight = MediaQuery.of(context).size.height;

                return Positioned(
                  left: petal.x * screenWidth,
                  top: petal.y * screenHeight,
                  child: Transform.rotate(
                    angle: petal.rotation,
                    child: Icon(
                      Icons.local_florist,
                      color: Colors.pinkAccent[200],
                      size: petal.size,
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _Petal {
  double x;
  double y;
  double speed;
  double size;
  double rotation;
  double rotationSpeed;

  _Petal({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });
}
