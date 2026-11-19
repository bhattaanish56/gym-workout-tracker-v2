import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_providers.dart';

class AboutYouStepScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AboutYouStepScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<AboutYouStepScreen> createState() => _AboutYouStepScreenState();
}

class _AboutYouStepScreenState extends ConsumerState<AboutYouStepScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DateTime? _dateOfBirth;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingStateProvider);
    _nameController = TextEditingController(text: state['name'] as String?);
    _dateOfBirth = state['dateOfBirth'] as DateTime?;
    _gender = state['gender'] as String?;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    if (_formKey.currentState!.validate()) {
      ref.read(onboardingStateProvider.notifier).updateData({
        'name': _nameController.text.trim(),
        'dateOfBirth': _dateOfBirth,
        'gender': _gender,
      });
      widget.onNext();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
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
            'About You',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us a bit about yourself',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              hintText: 'Select your date of birth',
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () => _selectDate(context),
            controller: TextEditingController(
              text: _dateOfBirth != null
                  ? '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}'
                  : '',
            ),
            validator: (value) {
              if (_dateOfBirth == null) {
                return 'Please select your date of birth';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Gender (Optional)',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Male'),
                selected: _gender == 'male',
                onSelected: (selected) {
                  setState(() => _gender = selected ? 'male' : null);
                },
              ),
              ChoiceChip(
                label: const Text('Female'),
                selected: _gender == 'female',
                onSelected: (selected) {
                  setState(() => _gender = selected ? 'female' : null);
                },
              ),
              ChoiceChip(
                label: const Text('Prefer not to say'),
                selected: _gender == 'prefer_not_to_say',
                onSelected: (selected) {
                  setState(() => _gender = selected ? 'prefer_not_to_say' : null);
                },
              ),
            ],
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
