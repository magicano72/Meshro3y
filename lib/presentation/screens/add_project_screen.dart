import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/formatters.dart';
import '../providers/machine_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/custom_text_field.dart';

class AddProjectScreen extends ConsumerStatefulWidget {
  const AddProjectScreen({super.key});

  @override
  ConsumerState<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends ConsumerState<AddProjectScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final Set<String> _selectedMachineIds = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add_to_photos,
                color: Theme.of(context).colorScheme.primary,
                size: isTablet ? 28 : 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'newProject'.tr,
              style: TextStyle(
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8, left: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
                size: isTablet ? 28 : 24,
              ),
              onPressed: _saveProject,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Name Section
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.folder,
                                color: Theme.of(context).colorScheme.primary,
                                size: isTablet ? 28 : 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'projectInfo'.tr,
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        SizedBox(
                          height: isTablet ? 75 : 70,
                          child: CustomTextField(
                            label: 'projectName'.tr,
                            controller: _nameController,
                            prefixIcon: Icons.folder_open,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 32 : 24),

              // Select Machines Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.construction,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: isTablet ? 24 : 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'selectMachines'.tr,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedMachineIds.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_selectedMachineIds.length} selected',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),

              if (machines.isEmpty)
                Container(
                  padding: EdgeInsets.all(isTablet ? 32 : 24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.construction,
                          size: isTablet ? 48 : 40,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'noMachinesAvailable'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: machines.length,
                  itemBuilder: (context, index) {
                    final machine = machines[index];
                    final isSelected = _selectedMachineIds.contains(machine.id);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Card(
                        elevation: isSelected ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16,
                            vertical: isTablet ? 12 : 8,
                          ),
                          value: isSelected,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedMachineIds.add(machine.id);
                              } else {
                                _selectedMachineIds.remove(machine.id);
                              }
                            });
                          },
                          title: Text(
                            machine.name,
                            style: TextStyle(
                              fontSize: isTablet ? 17 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${CurrencyFormatter.format(machine.pricePerHour)}/hour',
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2)
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.construction,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
