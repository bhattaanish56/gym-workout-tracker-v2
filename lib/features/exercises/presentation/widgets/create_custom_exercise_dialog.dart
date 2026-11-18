import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/muscle_group.dart';
import '../providers/exercise_providers.dart';

class CreateCustomExerciseDialog extends ConsumerStatefulWidget {
  const CreateCustomExerciseDialog({super.key});

  @override
  ConsumerState<CreateCustomExerciseDialog> createState() =>
      _CreateCustomExerciseDialogState();
}

class _CreateCustomExerciseDialogState
    extends ConsumerState<CreateCustomExerciseDialog> {
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  Equipment _equipment = Equipment.barbell;
  MuscleGroup _primaryMuscle = MuscleGroup.chest;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Name is required');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(exerciseRepositoryProvider);
      await repo.createCustomExercise(
        name: name,
        equipment: _equipment,
        primaryMuscle: _primaryMuscle,
        instructions: _instructionsController.text.trim().isEmpty
            ? null
            : _instructionsController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create exercise: $e';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1C1E23),
      title: const Text(
        'Create Custom Exercise',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Exercise Name *',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Equipment>(
              initialValue: _equipment,
              dropdownColor: const Color(0xFF1C1E23),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Equipment',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              items: Equipment.values.map((e) {
                return DropdownMenuItem(value: e, child: Text(e.label));
              }).toList(),
              onChanged: (value) => setState(() => _equipment = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MuscleGroup>(
              initialValue: _primaryMuscle,
              dropdownColor: const Color(0xFF1C1E23),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Primary Muscle',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              items: MuscleGroup.values.map((m) {
                return DropdownMenuItem(value: m, child: Text(m.label));
              }).toList(),
              onChanged: (value) => setState(() => _primaryMuscle = value!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _instructionsController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Instructions (optional)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
