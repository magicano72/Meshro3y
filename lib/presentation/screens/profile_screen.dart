import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/formatters.dart';
import '../providers/machine_provider.dart';
import '../providers/owner_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/empty_state.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final owner = ref.read(ownerProvider);
      if (owner != null) {
        _nameController.text = owner.name;
        _phoneController.text = owner.phone;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveOwner() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pleaseEnterName'.tr)),
      );
      return;
    }

    final owner = ref.read(ownerProvider);
    if (owner == null) {
      ref.read(ownerProvider.notifier).saveOwner(
            _nameController.text.trim(),
            _phoneController.text.trim(),
            const Uuid().v4(),
          );
    } else {
      ref.read(ownerProvider.notifier).updateOwner(
            _nameController.text.trim(),
            _phoneController.text.trim(),
          );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('profileSaved'.tr)),
    );
  }

  void _showMachineDialog({String? machineId}) {
    final machine = machineId != null
        ? ref.read(machineProvider.notifier).getMachineById(machineId)
        : null;

    final nameController = TextEditingController(text: machine?.name ?? '');
    final priceController = TextEditingController(
      text: machine?.pricePerHour.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth > 600;

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          title: Row(
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
              Expanded(
                child: Text(
                  machine == null ? 'addMachine'.tr : 'editMachine'.tr,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: isTablet ? 75 : 70,
                child: CustomTextField(
                  label: 'Machine Name'.tr,
                  controller: nameController,
                  prefixIcon: Icons.construction,
                ),
              ),
              SizedBox(height: isTablet ? 16 : 14),
              SizedBox(
                height: isTablet ? 75 : 70,
                child: CustomTextField(
                  label: 'Price per Hour'.tr,
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.attach_money,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              ),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 15 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    priceController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('fillAllFields'.tr)),
                  );
                  return;
                }

                final price = double.tryParse(priceController.text.trim());
                if (price == null || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('invalidPrice'.tr)),
                  );
                  return;
                }

                if (machine == null) {
                  ref.read(machineProvider.notifier).addMachine(
                        const Uuid().v4(),
                        nameController.text.trim(),
                        price,
                      );
                } else {
                  ref.read(machineProvider.notifier).updateMachine(
                        machine.id,
                        nameController.text.trim(),
                        price,
                      );
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: isTablet ? 12 : 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'save'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 15 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteMachine(String id, String name) {
    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth > 600;

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: isTablet ? 24 : 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'deleteMachine'.tr,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '${'deleteConfirm'.tr} "$name"?',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              ),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 15 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(machineProvider.notifier).deleteMachine(id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: isTablet ? 12 : 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'delete'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 15 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final machines = ref.watch(machineProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Responsive sizing
    final sectionSpacing = isTablet ? 32.0 : 24.0;
    final fieldSpacing = isTablet ? 20.0 : 16.0;
    final cardPadding = isTablet ? 24.0 : 20.0;
    final fontSize = isTablet ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
        elevation: 0,
        actions: [
          TextButton(
            child: Text(
              'save'.tr,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: _saveOwner,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner Info Section
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
                  padding: EdgeInsets.all(cardPadding),
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
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: isTablet ? 28 : 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ownerInfo'.tr,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: fieldSpacing + 4),
                      SizedBox(
                        height: isTablet ? 75 : 70,
                        child: CustomTextField(
                          label: 'Name'.tr,
                          controller: _nameController,
                          prefixIcon: Icons.badge,
                        ),
                      ),
                      SizedBox(height: fieldSpacing),
                      SizedBox(
                        height: isTablet ? 75 : 70,
                        child: CustomTextField(
                          label: 'Phone Number'.tr,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: sectionSpacing),

            // Machines Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        size: isTablet ? 24 : 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'machines'.tr,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: isTablet ? 28 : 24,
                    ),
                    onPressed: () => _showMachineDialog(),
                  ),
                ),
              ],
            ),
            SizedBox(height: fieldSpacing + 4),
            if (machines.isEmpty)
              EmptyState(
                icon: Icons.construction,
                message: 'noMachines'.tr,
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: machines.length,
                itemBuilder: (context, index) {
                  final machine = machines[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 16,
                          vertical: isTablet ? 12 : 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.construction,
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                          ),
                        ),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () => _showMachineDialog(
                                machineId: machine.id,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () => _deleteMachine(
                                machine.id,
                                machine.name,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
