import 'package:flutter/material.dart';

import '../../../core/models/ingredient.dart';
import '../../../core/services/admin_catalog_repository.dart';

class IngredientForm extends StatefulWidget {
  IngredientForm({
    super.key,
    this.initialIngredient,
    this.onSaved,
    this.onCancelled,
    AdminCatalogRepository? repository,
  }) : _repository = repository ?? AdminCatalogRepository();

  final Ingredient? initialIngredient;
  final ValueChanged<Ingredient>? onSaved;
  final VoidCallback? onCancelled;
  final AdminCatalogRepository _repository;

  @override
  State<IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends State<IngredientForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameFrController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _descriptionFrController;
  late final TextEditingController _descriptionEnController;
  late IngredientCategory _selectedCategory;
  bool _isAllergen = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final ingredient = widget.initialIngredient;
    _nameFrController = TextEditingController(text: ingredient?.name['fr'] ?? '');
    _nameEnController = TextEditingController(text: ingredient?.name['en'] ?? '');
    _descriptionFrController = TextEditingController(text: ingredient?.description?['fr'] ?? '');
    _descriptionEnController = TextEditingController(text: ingredient?.description?['en'] ?? '');
    _selectedCategory = ingredient?.category ?? IngredientCategory.other;
    _isAllergen = ingredient?.isAllergen ?? false;
  }

  @override
  void dispose() {
    _nameFrController.dispose();
    _nameEnController.dispose();
    _descriptionFrController.dispose();
    _descriptionEnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNameFields(),
          const SizedBox(height: 16),
          _buildCategoryAndAllergenRow(),
          const SizedBox(height: 16),
          _buildDescriptionFields(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSubmitting ? null : widget.onCancelled,
                child: const Text('Annuler'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.initialIngredient == null ? 'Enregistrer' : 'Mettre à jour'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameFields() {
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

  Widget _buildCategoryAndAllergenRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<IngredientCategory>(
            // ignore: deprecated_member_use
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Catégorie',
              border: OutlineInputBorder(),
            ),
            items: IngredientCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(_displayCategory(category)),
                  ),
                )
                .toList(),
            onChanged: (category) {
              if (category == null) return;
              setState(() => _selectedCategory = category);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CheckboxListTile(
            value: _isAllergen,
            contentPadding: EdgeInsets.zero,
            title: const Text('Allergène'),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _isAllergen = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionFields() {
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final ingredient = widget.initialIngredient;
    final name = <String, String>{
      'fr': _nameFrController.text.trim(),
      if (_nameEnController.text.trim().isNotEmpty) 'en': _nameEnController.text.trim(),
    };
    final description = <String, String>{
      if (_descriptionFrController.text.trim().isNotEmpty) 'fr': _descriptionFrController.text.trim(),
      if (_descriptionEnController.text.trim().isNotEmpty) 'en': _descriptionEnController.text.trim(),
    };

    Ingredient? result;
    bool success = false;
    try {
      if (ingredient == null) {
        result = await widget._repository.createIngredient(
          name: name,
          category: _selectedCategory,
          isAllergen: _isAllergen,
          description: description.isEmpty ? null : description,
        );
        success = result != null;
      } else {
        final updated = ingredient.copyWith(
          name: name,
          category: _selectedCategory,
          isAllergen: _isAllergen,
          description: description.isEmpty ? null : description,
          clearDescription: description.isEmpty,
        );
        success = await widget._repository.updateIngredient(updated);
        if (success) {
          result = updated;
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
        setState(() {
          _isSubmitting = false;
        });
      }
    }

    if (!success || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ingredient == null ? 'Ingrédient créé avec succès.' : 'Ingrédient mis à jour.',
        ),
      ),
    );
    widget.onSaved?.call(result ?? ingredient!);
  }

  String _displayCategory(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.hop:
        return 'Houblon';
      case IngredientCategory.yeast:
        return 'Levure';
      case IngredientCategory.grain:
        return 'Céréale';
      case IngredientCategory.other:
        return 'Autre';
    }
  }
}
