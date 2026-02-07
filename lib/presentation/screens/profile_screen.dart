import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
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
      builder: (context) => AlertDialog(
        title: Text(machine == null ? 'addMachine'.tr : 'editMachine'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Machine Name',
              controller: nameController,
              prefixIcon: Icons.construction,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Price per Hour',
              controller: priceController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.attach_money,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteMachine(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('deleteMachine'.tr),
        content: Text('${'deleteConfirm'.tr} "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(machineProvider.notifier).deleteMachine(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final machines = ref.watch(machineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveOwner,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ownerInfo'.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Name',
                      controller: _nameController,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'machines'.tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () => _showMachineDialog(),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.construction),
                      title: Text(machine.name),
                      subtitle: Text(
                        '${CurrencyFormatter.format(machine.pricePerHour)}/hour',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showMachineDialog(
                              machineId: machine.id,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteMachine(
                              machine.id,
                              machine.name,
                            ),
                          ),
                        ],
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
