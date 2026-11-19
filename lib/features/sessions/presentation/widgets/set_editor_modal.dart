import 'package:flutter/material.dart';
import '../../domain/models/performed_set.dart';
import '../../../../core/domain/value_objects/weight.dart';

class SetEditorModal extends StatefulWidget {
  final PerformedSet set;
  final int setNumber;
  final void Function(PerformedSet updatedSet) onSave;

  const SetEditorModal({
    super.key,
    required this.set,
    required this.setNumber,
    required this.onSave,
  });

  @override
  State<SetEditorModal> createState() => _SetEditorModalState();
}

class _SetEditorModalState extends State<SetEditorModal> {
  late FixedExtentScrollController _typeController;
  late FixedExtentScrollController _repsController;
  late FixedExtentScrollController _weightController;

  late SetType _selectedType;
  late int _selectedReps;
  late double _selectedWeight;
  bool _useFineIncrement = false;

  late int _selectedTypeIndex;
  late int _selectedRepsIndex;
  late int _selectedWeightIndex;

  static const List<SetType> _setTypes = [
    SetType.warmup,
    SetType.working,
    SetType.drop,
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.set.setType;
    _selectedReps = widget.set.reps ?? 8;
    _selectedWeight = widget.set.loadGrams != null
        ? widget.set.loadGrams!.displayValue(WeightUnit.kg)
        : 50.0;

    _selectedTypeIndex = _setTypes.indexOf(_selectedType);
    _typeController = FixedExtentScrollController(initialItem: _selectedTypeIndex);

    _selectedRepsIndex = (_selectedReps - 1).clamp(0, 49);
    _repsController = FixedExtentScrollController(initialItem: _selectedRepsIndex);

    _selectedWeightIndex = _getWeightIndex(_selectedWeight);
    _weightController = FixedExtentScrollController(initialItem: _selectedWeightIndex);
  }

  @override
  void dispose() {
    _typeController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  int _getWeightIndex(double weight) {
    if (_useFineIncrement) {
      return (weight * 2).round();
    } else {
      return weight.round();
    }
  }

  double _getWeightFromIndex(int index) {
    if (_useFineIncrement) {
      return index / 2.0;
    } else {
      return index.toDouble();
    }
  }

  void _toggleWeightIncrement() {
    setState(() {
      final currentWeight = _selectedWeight;
      _useFineIncrement = !_useFineIncrement;
      _selectedWeightIndex = _getWeightIndex(currentWeight);
      _weightController.jumpToItem(_selectedWeightIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Set ${widget.setNumber}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Pickers
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  // Type picker
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'TYPE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListWheelScrollView(
                            controller: _typeController,
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedTypeIndex = index;
                                _selectedType = _setTypes[index];
                              });
                            },
                            children: List.generate(_setTypes.length, (index) {
                              final type = _setTypes[index];
                              final isSelected = index == _selectedTypeIndex;
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.orange.withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    type.displayName,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reps picker
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'REPS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListWheelScrollView(
                            controller: _repsController,
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedRepsIndex = index;
                                _selectedReps = index + 1;
                              });
                            },
                            children: List.generate(50, (index) {
                              final reps = index + 1;
                              final isSelected = index == _selectedRepsIndex;
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.orange.withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$reps',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // KG picker
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'KG',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: GestureDetector(
                            onLongPressStart: (_) => _toggleWeightIncrement(),
                            child: ListWheelScrollView(
                              controller: _weightController,
                              itemExtent: 50,
                              physics: const FixedExtentScrollPhysics(),
                              diameterRatio: 1.5,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  _selectedWeightIndex = index;
                                  _selectedWeight = _getWeightFromIndex(index);
                                });
                              },
                              children: List.generate(
                                _useFineIncrement ? 601 : 301,
                                (index) {
                                  final weight = _getWeightFromIndex(index);
                                  final isSelected = index == _selectedWeightIndex;
                                  return Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.orange.withValues(alpha: 0.2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        weight.toStringAsFixed(_useFineIncrement ? 1 : 0),
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? theme.colorScheme.onSurface
                                              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Info banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Weight: Slide for 1 kg steps.\nHold the number to switch to 0.5 kg steps\n(e.g., 50 → 50.5 → 51.0).',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        final updatedSet = widget.set.copyWith(
                          setType: _selectedType,
                          reps: _selectedReps,
                          loadGrams: WeightGrams.fromKg(_selectedWeight),
                        );
                        widget.onSave(updatedSet);
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Set'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
