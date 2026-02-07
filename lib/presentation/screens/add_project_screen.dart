import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/machine_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/custom_text_field.dart';

class AddProjectScreen extends ConsumerStatefulWidget {
  const AddProjectScreen({super.key});

  @override
  ConsumerState<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends ConsumerState<AddProjectScreen> {
  final _nameController = TextEditingController();
  final Set<String> _selectedMachineIds = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProject() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pleaseEnterProjectName'.tr)),
      );
      return;
    }

    if (_selectedMachineIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('selectMachine'.tr)),
      );
      return;
    }

    ref.read(projectProvider.notifier).addProject(
          const Uuid().v4(),
          _nameController.text.trim(),
          _selectedMachineIds.toList(),
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('projectCreated'.tr)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final machines = ref.watch(machineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('newProject'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProject,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Project Name',
              controller: _nameController,
              prefixIcon: Icons.folder,
            ),
            const SizedBox(height: 24),
            Text(
              'selectMachines'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (machines.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'noMachinesAvailable'.tr,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: machines.length,
                  itemBuilder: (context, index) {
                    final machine = machines[index];
                    final isSelected = _selectedMachineIds.contains(machine.id);

                    return Card(
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedMachineIds.add(machine.id);
                            } else {
                              _selectedMachineIds.remove(machine.id);
                            }
                          });
                        },
                        title: Text(machine.name),
                        subtitle: Text('\$${machine.pricePerHour}/hour'),
                        secondary: const Icon(Icons.construction),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
