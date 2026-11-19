import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/fitness_profile.dart';
import '../../domain/models/fitness_goal.dart';
import '../../domain/models/experience_level.dart';
import '../../domain/models/activity_level.dart';
import '../providers/onboarding_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class FitnessSettingsScreen extends ConsumerStatefulWidget {
  const FitnessSettingsScreen({super.key});

  @override
  ConsumerState<FitnessSettingsScreen> createState() => _FitnessSettingsScreenState();
}

class _FitnessSettingsScreenState extends ConsumerState<FitnessSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  FitnessGoal? _fitnessGoal;
  ExperienceLevel? _experienceLevel;
  ActivityLevel? _activityLevel;
  int? _workoutDaysPerWeek;
  String? _trainingLocation;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetCaloriesController;
  late TextEditingController _targetProteinController;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _targetCaloriesController = TextEditingController();
    _targetProteinController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetCaloriesController.dispose();
    _targetProteinController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;

    final profile = await ref.read(onboardingRepositoryProvider).getFitnessProfile(userId);

    if (profile != null && mounted) {
      setState(() {
        _fitnessGoal = profile.fitnessGoal;
        _experienceLevel = profile.experienceLevel;
        _activityLevel = profile.activityLevel;
        _workoutDaysPerWeek = profile.workoutDaysPerWeek;
        _trainingLocation = profile.trainingLocation;
        _heightController.text = profile.heightCm?.toString() ?? '';
        _weightController.text = profile.currentWeightKg?.toStringAsFixed(1) ?? '';
        _targetCaloriesController.text = profile.targetCalories?.toString() ?? '';
        _targetProteinController.text = profile.targetProteinGrams?.toString() ?? '';
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final userId = ref.read(authRepositoryProvider).currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final heightCm = int.tryParse(_heightController.text.trim());
      final weightKg = double.tryParse(_weightController.text.trim());
      final targetCalories = int.tryParse(_targetCaloriesController.text.trim());
      final targetProtein = int.tryParse(_targetProteinController.text.trim());

      final profile = FitnessProfile(
        userId: userId,
        heightCm: heightCm,
        currentWeightGrams: weightKg != null ? (weightKg * 1000).round() : null,
        fitnessGoal: _fitnessGoal,
        experienceLevel: _experienceLevel,
        activityLevel: _activityLevel,
        workoutDaysPerWeek: _workoutDaysPerWeek,
        trainingLocation: _trainingLocation,
        hasCompletedOnboarding: true,
        targetCalories: targetCalories,
        targetProteinGrams: targetProtein,
      );

      await ref.read(onboardingRepositoryProvider).saveFitnessProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Settings saved successfully'),
            backgroundColor: Colors.green.shade700,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fitness Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Settings'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Body Details',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Current Weight (kg)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Fitness Goal',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FitnessGoal.values.map((goal) {
                return ChoiceChip(
                  label: Text(goal.label),
                  selected: _fitnessGoal == goal,
                  onSelected: (selected) {
                    setState(() => _fitnessGoal = selected ? goal : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text(
              'Experience Level',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExperienceLevel.values.map((level) {
                return ChoiceChip(
                  label: Text(level.label),
                  selected: _experienceLevel == level,
                  onSelected: (selected) {
                    setState(() => _experienceLevel = selected ? level : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text(
              'Activity Level',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...ActivityLevel.values.map((level) {
              return RadioListTile<ActivityLevel>(
                title: Text(level.label),
                subtitle: Text(level.description),
                value: level,
                groupValue: _activityLevel,
                onChanged: (value) {
                  setState(() => _activityLevel = value);
                },
              );
            }),
            const SizedBox(height: 32),
            Text(
              'Workout Frequency',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final days = index + 1;
                return ChoiceChip(
                  label: Text('$days day${days > 1 ? 's' : ''}'),
                  selected: _workoutDaysPerWeek == days,
                  onSelected: (selected) {
                    setState(() => _workoutDaysPerWeek = selected ? days : null);
                  },
                );
              }),
            ),
            const SizedBox(height: 32),
            Text(
              'Training Location',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['gym', 'home', 'both'].map((location) {
                return ChoiceChip(
                  label: Text(location[0].toUpperCase() + location.substring(1)),
                  selected: _trainingLocation == location,
                  onSelected: (selected) {
                    setState(() => _trainingLocation = selected ? location : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text(
              'Nutrition Targets',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetCaloriesController,
              decoration: const InputDecoration(labelText: 'Target Calories (kcal/day)'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetProteinController,
              decoration: const InputDecoration(labelText: 'Target Protein (g/day)'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isSaving ? null : _saveProfile,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
