import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewMatch Firebase Test',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firestore Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final firestore = FirebaseFirestore.instance;

              // Ajouter un document dans une collection "test"
              await firestore.collection('test').add({
                'message': 'Hello BrewMatch',
                'timestamp': FieldValue.serverTimestamp(),
              });

              print('✅ Document ajouté !');
            },
            child: const Text('Ajouter dans Firestore'),
          ),
        ),
      ),
    );
  }
}