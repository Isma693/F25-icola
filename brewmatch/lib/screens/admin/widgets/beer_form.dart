import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/models/beer.dart';
import '../../../core/models/ingredient.dart';
import '../../../core/services/admin_catalog_repository.dart';
import 'ingredient_form.dart';

class BeerForm extends StatefulWidget {
  BeerForm({
    super.key,
    this.initialBeer,
    this.onSaved,
    this.onCancelled,
    AdminCatalogRepository? repository,
  }) : _repository = repository ?? AdminCatalogRepository();

  final Beer? initialBeer;
  final ValueChanged<Beer>? onSaved;
  final VoidCallback? onCancelled;
  final AdminCatalogRepository _repository;

  @override
  State<BeerForm> createState() => _BeerFormState();
}

class _BeerFormState extends State<BeerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameFrController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _styleController;
  late final TextEditingController _abvController;
  late final TextEditingController _descriptionFrController;
  late final TextEditingController _descriptionEnController;

  double _bitterness = 5;
  double _sweetness = 5;
  double _carbonation = 5;
  bool _isSubmitting = false;
  late final FirebaseFirestore _firestore;
  final Set<String> _selectedIngredientIds = <String>{};
  bool _showIngredientError = false;

  @override
  void initState() {
    super.initState();
    final beer = widget.initialBeer;
    _firestore = FirebaseFirestore.instance;

    _nameFrController = TextEditingController(text: beer?.name['fr'] ?? '');
    _nameEnController = TextEditingController(text: beer?.name['en'] ?? '');
    _styleController = TextEditingController(text: beer?.style ?? '');
    _abvController = TextEditingController(
      text: beer != null ? beer.alcoholLevel.toString() : '',
    );
    _descriptionFrController = TextEditingController(text: beer?.description?['fr'] ?? '');
    _descriptionEnController = TextEditingController(text: beer?.description?['en'] ?? '');
    _bitterness = beer?.bitternessLevel ?? 5;
    _sweetness = beer?.sweetnessLevel ?? 5;
    _carbonation = beer?.carbonationLevel ?? 5;

    if (beer != null) {
      for (final ref in beer.ingredients) {
        _selectedIngredientIds.add(ref.id);
      }
    }
  }

  @override
  void dispose() {
    _nameFrController.dispose();
    _nameEnController.dispose();
    _styleController.dispose();
    _abvController.dispose();
    _descriptionFrController.dispose();
    _descriptionEnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNameSection(),
            const SizedBox(height: 16),
            _buildStyleAndAbv(),
            const SizedBox(height: 16),
            _buildTasteProfile(),
            const SizedBox(height: 16),
            _buildIngredientSelector(),
            const SizedBox(height: 16),
            _buildDescriptions(),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 12,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : widget.onCancelled,
                    child: const Text('Annuler'),
                  ),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.initialBeer == null ? 'Enregistrer' : 'Mettre à jour'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameFrController,
          decoration: const InputDecoration(
            labelText: 'Nom (FR)*',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le nom français est requis.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameEnController,
          decoration: const InputDecoration(
            labelText: 'Nom (EN)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildStyleAndAbv() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _styleController,
            decoration: const InputDecoration(
              labelText: 'Style*',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le style est requis.';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _abvController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Degré d’alcool (%)*',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              final abv = double.tryParse(trimmed);
              if (trimmed.isEmpty || abv == null) {
                return 'Indique un nombre valide.';
              }
              if (abv < 0 || abv > 30) {
                return 'Entre 0 et 30%.';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTasteProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profil gustatif',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildSlider(
          label: 'Amertume',
          value: _bitterness,
          onChanged: (value) => setState(() => _bitterness = value),
        ),
        _buildSlider(
          label: 'Sucre',
          value: _sweetness,
          onChanged: (value) => setState(() => _sweetness = value),
        ),
        _buildSlider(
          label: 'Gaz',
          value: _carbonation,
          onChanged: (value) => setState(() => _carbonation = value),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 20,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildIngredientSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ingrédients',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _openIngredientCreation,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<Ingredient>>(
          stream: widget._repository.watchIngredients(),
          builder: (context, snapshot) {
            final ingredients = snapshot.data ?? [];
            if (ingredients.isEmpty) {
              return const Text('Aucun ingrédient disponible.');
            }
            return Wrap(
              spacing: 8,
              children: [
                for (final ingredient in ingredients)
                  FilterChip(
                    label: Text(ingredient.name['fr'] ?? ingredient.id),
                    selected: _selectedIngredientIds.contains(ingredient.id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedIngredientIds.add(ingredient.id);
                        } else {
                          _selectedIngredientIds.remove(ingredient.id);
                        }
                        if (_selectedIngredientIds.isNotEmpty) {
                          _showIngredientError = false;
                        }
                      });
                    },
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        if (_showIngredientError && _selectedIngredientIds.isEmpty)
          const Text(
            'Sélectionne au moins un ingrédient.',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildDescriptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _descriptionFrController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Description (FR)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionEnController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Description (EN)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Future<void> _openIngredientCreation() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: IngredientForm(
              onSaved: (ingredient) {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIngredientIds.add(ingredient.id);
                  _showIngredientError = false;
                });
              },
              onCancelled: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIngredientIds.isEmpty) {
      setState(() {
        _showIngredientError = true;
      });
      return;
    }

    setState(() => _isSubmitting = true);

    final description = <String, String>{
      if (_descriptionFrController.text.trim().isNotEmpty) 'fr': _descriptionFrController.text.trim(),
      if (_descriptionEnController.text.trim().isNotEmpty) 'en': _descriptionEnController.text.trim(),
    };
    final name = <String, String>{
      'fr': _nameFrController.text.trim(),
      if (_nameEnController.text.trim().isNotEmpty) 'en': _nameEnController.text.trim(),
    };
    final abv = double.parse(_abvController.text.trim());
    final ingredientRefs = _selectedIngredientIds
        .map(
          (id) => _firestore.collection('ingredients').doc(id),
        )
        .toList();

    Beer? savedBeer;
    bool success = false;

    try {
      if (widget.initialBeer == null) {
        final beer = Beer(
          id: '',
          name: name,
          style: _styleController.text.trim(),
          alcoholLevel: abv,
          bitternessLevel: _bitterness,
          sweetnessLevel: _sweetness,
          carbonationLevel: _carbonation,
          ingredients: ingredientRefs,
          description: description.isEmpty ? null : description,
          onTap: false,
        );
        savedBeer = await widget._repository.createBeer(beer);
        success = savedBeer != null;
      } else {
        final updated = widget.initialBeer!.copyWith(
          name: name,
          style: _styleController.text.trim(),
          alcoholLevel: abv,
          bitternessLevel: _bitterness,
          sweetnessLevel: _sweetness,
          carbonationLevel: _carbonation,
          description: description.isEmpty ? null : description,
          ingredients: ingredientRefs,
          clearDescription: description.isEmpty,
        );
        success = await widget._repository.updateBeer(updated);
        if (success) {
          savedBeer = updated;
        }
      }
    } catch (e) {
      success = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }

    if (!success || savedBeer == null || !mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.initialBeer == null ? 'Bière créée avec succès.' : 'Bière mise à jour.'),
      ),
    );
    widget.onSaved?.call(savedBeer);
  }
}
