import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_providers.dart';

class BodyDetailsStepScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BodyDetailsStepScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<BodyDetailsStepScreen> createState() => _BodyDetailsStepScreenState();
}

class _BodyDetailsStepScreenState extends ConsumerState<BodyDetailsStepScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _goalWeightController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingStateProvider);
    _heightController = TextEditingController(
      text: (state['heightCm'] as int?)?.toString() ?? '',
    );
    final currentWeightGrams = state['currentWeightGrams'] as int?;
    _weightController = TextEditingController(
      text: currentWeightGrams != null ? (currentWeightGrams / 1000).toStringAsFixed(1) : '',
    );
    final goalWeightGrams = state['goalWeightGrams'] as int?;
    _goalWeightController = TextEditingController(
      text: goalWeightGrams != null ? (goalWeightGrams / 1000).toStringAsFixed(1) : '',
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    if (_formKey.currentState!.validate()) {
      final heightCm = int.tryParse(_heightController.text.trim());
      final weightKg = double.tryParse(_weightController.text.trim());
      final goalWeightKg = _goalWeightController.text.trim().isNotEmpty
          ? double.tryParse(_goalWeightController.text.trim())
          : null;

      ref.read(onboardingStateProvider.notifier).updateData({
        'heightCm': heightCm,
        'currentWeightGrams': weightKg != null ? (weightKg * 1000).round() : null,
        'goalWeightGrams': goalWeightKg != null ? (goalWeightKg * 1000).round() : null,
      });
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Body Details',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us calculate your nutrition targets',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              hintText: 'e.g., 175',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your height';
              }
              final height = int.tryParse(value);
              if (height == null || height < 100 || height > 250) {
                return 'Please enter a valid height (100-250 cm)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Current Weight (kg)',
              hintText: 'e.g., 75.5',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your current weight';
              }
              final weight = double.tryParse(value);
              if (weight == null || weight < 30 || weight > 300) {
                return 'Please enter a valid weight (30-300 kg)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _goalWeightController,
            decoration: const InputDecoration(
              labelText: 'Goal Weight (kg) - Optional',
              hintText: 'e.g., 80.0',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final weight = double.tryParse(value);
                if (weight == null || weight < 30 || weight > 300) {
                  return 'Please enter a valid weight (30-300 kg)';
                }
              }
              return null;
            },
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _saveAndNext,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
