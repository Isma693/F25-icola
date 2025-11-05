// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'core/models/ingredient.dart';
// ...existing code... (beer model import removed - unused in this debug runner)
import 'core/services/localized_text.dart';
import 'core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'BrewMatch Admin', home: const DebugHome());
  }
}

class DebugHome extends StatefulWidget {
  const DebugHome({super.key});

  @override
  State<DebugHome> createState() => _DebugHomeState();
}

class _DebugHomeState extends State<DebugHome> {
  final List<String> _logs = [];

  // Auth test controllers
  final _authEmail = TextEditingController();
  final _authPassword = TextEditingController();

  // Ingredient form controllers
  final _ingNameEn = TextEditingController();
  final _ingNameFr = TextEditingController();
  final _ingDescEn = TextEditingController();
  IngredientCategory _ingCategory = IngredientCategory.hop;
  bool _ingAllergen = false;

  // Beer form controllers
  final _beerNameEn = TextEditingController();
  final _beerNameFr = TextEditingController();
  final _beerStyle = TextEditingController();
  final _beerAlcohol = TextEditingController();
  final _beerBitterness = TextEditingController();
  final _beerSweetness = TextEditingController();
  final _beerCarbonation = TextEditingController();
  final _beerImage = TextEditingController();
  final _beerDescEn = TextEditingController();
  List<DocumentReference<Map<String, dynamic>>> _selectedIngredients = [];

  String? _selectedBeerId;
  Map<String, dynamic>? _selectedBeerData;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes for quick feedback
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _log('Auth state changed: ${user?.uid ?? 'signed out'}');
    });
  }

  void _log(String message) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toIso8601String()}  $message');
    });
  }

  Future<void> _trySignIn() async {
    try {
      final email = _authEmail.text;
      final pass = _authPassword.text;
      final cred = await AuthService.instance.signIn(email, pass);
      _log('Signed in: ${cred.user?.email} (uid: ${cred.user?.uid})');
    } catch (e) {
      _log('SignIn error: $e');
    }
  }

  Future<void> _trySignUp() async {
    try {
      final email = _authEmail.text;
      final pass = _authPassword.text;
      final cred = await AuthService.instance.signUp(email, pass);
      _log('Signed up: ${cred.user?.email} (uid: ${cred.user?.uid})');
    } catch (e) {
      _log('SignUp error: $e');
    }
  }

  Future<void> _trySignOut() async {
    try {
      await AuthService.instance.signOut();
      _log('Signed out');
    } catch (e) {
      _log('SignOut error: $e');
    }
  }

  Future<void> _addIngredient() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final data = {
        'name': {'en': _ingNameEn.text, 'fr': _ingNameFr.text},
        'category': _ingCategory.value,
        'isAllergen': _ingAllergen,
        'description': {'en': _ingDescEn.text},
      };
      final ref = await firestore.collection('ingredients').add(data);
      _log('Ingredient added: ${ref.path}');
      _clearIngredientForm();
    } catch (e) {
      _log('Error adding ingredient: $e');
    }
  }

  void _clearIngredientForm() {
    _ingNameEn.clear();
    _ingNameFr.clear();
    _ingDescEn.clear();
    _ingCategory = IngredientCategory.hop;
    _ingAllergen = false;
  }

  Future<void> _pickIngredientsDialog() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('ingredients').get();
    final docs = snapshot.docs;
    final Map<String, bool> selected = {};
    for (final doc in docs) {
      selected[doc.id] = _selectedIngredients.any(
        (r) => r.path == doc.reference.path,
      );
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select ingredients'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: docs.map((doc) {
                final nameMap = LocalizedText.parse(doc.data()['name']);
                final label =
                    nameMap['en'] ??
                    nameMap.values.firstWhere(
                      (_) => true,
                      orElse: () => doc.id,
                    );
                return CheckboxListTile(
                  value: selected[doc.id] ?? false,
                  title: Text(label),
                  onChanged: (v) =>
                      setState(() => selected[doc.id] = v ?? false),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _selectedIngredients = docs
                    .where((d) => selected[d.id] == true)
                    .map(
                      (d) => d.reference.withConverter<Map<String, dynamic>>(
                        fromFirestore: (snap, _) =>
                            snap.data() ?? <String, dynamic>{},
                        toFirestore: (value, _) => value,
                      ),
                    )
                    .toList();
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addBeer() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final alcohol = double.tryParse(_beerAlcohol.text) ?? 0.0;
      final bitterness = double.tryParse(_beerBitterness.text) ?? 0.0;
      final sweetness = double.tryParse(_beerSweetness.text) ?? 0.0;
      final carbonation = double.tryParse(_beerCarbonation.text) ?? 0.0;

      final data = {
        'name': {'en': _beerNameEn.text, 'fr': _beerNameFr.text},
        'style': _beerStyle.text,
        'alcoholLevel': alcohol,
        'bitternessLevel': bitterness,
        'sweetnessLevel': sweetness,
        'carbonationLevel': carbonation,
        'description': {'en': _beerDescEn.text},
        'ingredients': _selectedIngredients.map((r) => r).toList(),
        'imageUrl': _beerImage.text.isEmpty ? null : _beerImage.text,
        'onTap': false,
      };

      final ref = await firestore.collection('beers').add(data);
      _log('Beer added: ${ref.path}');
      _clearBeerForm();
    } catch (e) {
      _log('Error adding beer: $e');
    }
  }

  void _clearBeerForm() {
    _beerNameEn.clear();
    _beerNameFr.clear();
    _beerStyle.clear();
    _beerAlcohol.clear();
    _beerBitterness.clear();
    _beerSweetness.clear();
    _beerCarbonation.clear();
    _beerImage.clear();
    _beerDescEn.clear();
    _selectedIngredients = [];
  }

  Future<void> _selectBeer(String? id) async {
    setState(() {
      _selectedBeerId = id;
      _selectedBeerData = null;
    });
    if (id == null) return;
    final firestore = FirebaseFirestore.instance;
    final snap = await firestore.collection('beers').doc(id).get();
    setState(() {
      _selectedBeerData = snap.data();
    });
  }

  @override
  void dispose() {
    _authEmail.dispose();
    _authPassword.dispose();
    _ingNameEn.dispose();
    _ingNameFr.dispose();
    _ingDescEn.dispose();
    _beerNameEn.dispose();
    _beerNameFr.dispose();
    _beerStyle.dispose();
    _beerAlcohol.dispose();
    _beerBitterness.dispose();
    _beerSweetness.dispose();
    _beerCarbonation.dispose();
    _beerImage.dispose();
    _beerDescEn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin — Beers & Ingredients')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Auth (test)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _authEmail,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _authPassword,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _trySignIn,
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _trySignUp,
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _trySignOut,
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text(
                'Add Ingredient',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingNameEn,
                      decoration: const InputDecoration(labelText: 'Name (en)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _ingNameFr,
                      decoration: const InputDecoration(labelText: 'Name (fr)'),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _ingDescEn,
                decoration: const InputDecoration(
                  labelText: 'Description (en)',
                ),
              ),
              Row(
                children: [
                  const Text('Category:'),
                  const SizedBox(width: 8),
                  DropdownButton<IngredientCategory>(
                    value: _ingCategory,
                    onChanged: (v) => setState(
                      () => _ingCategory = v ?? IngredientCategory.hop,
                    ),
                    items: IngredientCategory.values
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.value)),
                        )
                        .toList(),
                  ),
                  const SizedBox(width: 16),
                  Checkbox(
                    value: _ingAllergen,
                    onChanged: (v) => setState(() => _ingAllergen = v ?? false),
                  ),
                  const Text('Allergen'),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _addIngredient,
                    child: const Text('Add Ingredient'),
                  ),
                ],
              ),
              const Divider(height: 24),

              const Text(
                'Add Beer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _beerNameEn,
                      decoration: const InputDecoration(labelText: 'Name (en)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _beerNameFr,
                      decoration: const InputDecoration(labelText: 'Name (fr)'),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _beerStyle,
                decoration: const InputDecoration(labelText: 'Style'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _beerAlcohol,
                      decoration: const InputDecoration(
                        labelText: 'Alcohol level',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _beerBitterness,
                      decoration: const InputDecoration(
                        labelText: 'Bitterness',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _beerSweetness,
                      decoration: const InputDecoration(labelText: 'Sweetness'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _beerCarbonation,
                      decoration: const InputDecoration(
                        labelText: 'Carbonation',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _beerImage,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: _beerDescEn,
                decoration: const InputDecoration(
                  labelText: 'Description (en)',
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickIngredientsDialog,
                    child: const Text('Select Ingredients'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('${_selectedIngredients.length} selected'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addBeer,
                    child: const Text('Add Beer'),
                  ),
                ],
              ),
              const Divider(height: 24),

              const Text(
                'Beers in DB',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('beers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  return DropdownButton<String>(
                    value: _selectedBeerId,
                    hint: const Text('Select a beer'),
                    isExpanded: true,
                    items: docs.map((d) {
                      final nameMap = LocalizedText.parse(d.data()['name']);
                      final label =
                          nameMap['en'] ??
                          nameMap.values.firstWhere(
                            (_) => true,
                            orElse: () => d.id,
                          );
                      return DropdownMenuItem(value: d.id, child: Text(label));
                    }).toList(),
                    onChanged: (v) => _selectBeer(v),
                  );
                },
              ),

              const SizedBox(height: 12),
              if (_selectedBeerData != null) ...[
                const Text(
                  'Selected beer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Name: ${LocalizedText.resolveBest(LocalizedText.parse(_selectedBeerData!['name']), 'en')}',
                ),
                Text('Style: ${_selectedBeerData!['style'] ?? ''}'),
                Text('Alcohol: ${_selectedBeerData!['alcoholLevel'] ?? ''}'),
                Text(
                  'Bitterness: ${_selectedBeerData!['bitternessLevel'] ?? ''}',
                ),
                Text(
                  'Sweetness: ${_selectedBeerData!['sweetnessLevel'] ?? ''}',
                ),
                Text(
                  'Carbonation: ${_selectedBeerData!['carbonationLevel'] ?? ''}',
                ),
              ],

              const Divider(height: 24),
              const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) => Text(_logs[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
