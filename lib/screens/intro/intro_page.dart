import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                'lib/assets/images/logo.png',
                                height: 220,
                              ),
                            ),

                            const SizedBox(width: 40),

                            Expanded(
                              flex: 1,
                              child: _buildTextContent(context),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: Image.asset(
                                'lib/assets/images/logo.png',
                                height: 240,
                              ),
                            ),
                            const SizedBox(height: 48),
                            _buildTextContent(context),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Flower House",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        const SizedBox(height: 16),

        Text(
          "Fresh flowers for pickup or delivery every day",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 48),

        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Get started",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
