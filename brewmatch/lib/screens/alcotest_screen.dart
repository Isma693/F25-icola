import 'package:flutter/material.dart';

/// Easter egg screen to host the future Alcotest mini experience.
/// TODO: Replace placeholder copy and wire the actual test workflow.
class AlcotestScreen extends StatelessWidget {
  static const routeName = '/alcotest';

  const AlcotestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alcotest'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, size: 72, color: Colors.orange.shade300),
              const SizedBox(height: 24),
              const Text(
                'Bientôt un mini-jeu pour découvrir ton mood du moment !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'En attendant, continue d’explorer les bières BrewMatch.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
