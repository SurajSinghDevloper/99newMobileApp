import 'package:flutter/material.dart';

class LandingPageHeader extends StatelessWidget {
  const LandingPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF36069), // Light Red
            Color(0xFFF44336), // Red
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/99logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
