import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_flower_shop/screens/intro/pulsing_button.dart';

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
          "Flower House Helsinki",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        const SizedBox(height: 16),

        Text(
          "Fresh flowers for pickup or delivery every day",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              "Kamppi, Helsinki",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),

        const SizedBox(height: 48),

        PulsingButton(
          text: "Get started",
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ],
    );
  }
}
