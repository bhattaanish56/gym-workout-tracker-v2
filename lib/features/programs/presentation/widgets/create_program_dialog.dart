import 'package:flutter/material.dart';
import '../../domain/models/program.dart';

class CreateProgramDialog extends StatefulWidget {
  final Function(String name, String description, ScheduleMode scheduleMode)
  onCreated;

  const CreateProgramDialog({super.key, required this.onCreated});

  @override
  State<CreateProgramDialog> createState() => _CreateProgramDialogState();
}

class _CreateProgramDialogState extends State<CreateProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  ScheduleMode _scheduleMode = ScheduleMode.flexibleRotation;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Workout Plan'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Plan Name',
                  hintText: 'e.g. My Workout Plan',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Describe your plan',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule Mode',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  RadioListTile<ScheduleMode>(
                    title: const Text('Flexible Rotation'),
                    subtitle: const Text('Next workout rotates automatically'),
                    value: ScheduleMode.flexibleRotation,
                    groupValue: _scheduleMode,
                    onChanged: (value) {
                      setState(() => _scheduleMode = value!);
                    },
                  ),
                  RadioListTile<ScheduleMode>(
                    title: const Text('Fixed Weekly'),
                    subtitle: const Text('Choose workout each time'),
                    value: ScheduleMode.fixedWeekly,
                    groupValue: _scheduleMode,
                    onChanged: (value) {
                      setState(() => _scheduleMode = value!);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onCreated(
                _nameController.text.trim(),
                _descriptionController.text.trim(),
                _scheduleMode,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
