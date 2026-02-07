import 'package:Meshro3y/data/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/formatters.dart';
import '../providers/machine_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/project_provider.dart';
import '../providers/work_log_provider.dart';
import 'payments_screen.dart';
import 'pdf_invoice_screen.dart';
import 'work_log_screen.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
  });

  void _showAddMachineDialog(BuildContext context, WidgetRef ref) {
    final project =
        ref.read(projectProvider.notifier).getProjectById(projectId);
    if (project == null) return;

    final allMachines = ref.read(machineProvider);
    final availableMachines =
        allMachines.where((m) => !project.machineIds.contains(m.id)).toList();

    if (availableMachines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('selectMachines'.tr)),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('selectMachines'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableMachines.length,
            itemBuilder: (context, index) {
              final machine = availableMachines[index];
              return ListTile(
                leading: const Icon(Icons.construction),
                title: Text(machine.name),
                subtitle: Text(
                    '${CurrencyFormatter.format(machine.pricePerHour)}/hour'),
                onTap: () {
                  ref.read(projectProvider.notifier).addMachineToProject(
                        projectId,
                        machine.id,
                      );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectProvider);

    // Find the project in the list
    ProjectModel? project;
    try {
      project = projects.firstWhere((p) => p.id == projectId);
    } catch (e) {
      project = null;
    }

    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project Not Found')),
        body: const Center(child: Text('Project not found')),
      );
    }

    final workLogs = ref.watch(projectWorkLogsProvider(projectId));
    final payments = ref.watch(paymentProvider(projectId));

    // Calculate totals
    final totalCost = workLogs.fold<double>(
      0.0,
      (sum, log) => sum + log.totalPrice,
    );
    final totalPaid = payments.fold<double>(
      0.0,
      (sum, payment) => sum + payment.amount,
    );
    final remaining = totalCost - totalPaid;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          TextButton(
            child: Text('الفاتورة'.tr,
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfInvoiceScreen(projectId: projectId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Financial Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'financialSummary'.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    _buildSummaryRow('totalCost'.tr, totalCost, context),
                    _buildSummaryRow('totalPaid'.tr, totalPaid, context,
                        color: Colors.green),
                    _buildSummaryRow('remaining'.tr, remaining, context,
                        color: remaining > 0 ? Colors.red : Colors.green,
                        isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payments Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'payments'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentsScreen(projectId: projectId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right),
                  label: Text('View All'.tr),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Machines Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'machines'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () => _showAddMachineDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: project.machineIds.length,
              itemBuilder: (context, index) {
                final machineId = project!.machineIds[index];
                final machine = ref
                    .read(machineProvider.notifier)
                    .getMachineById(machineId);

                if (machine == null) return const SizedBox.shrink();

                final machineLogs = workLogs
                    .where((log) => log.machineId == machineId)
                    .toList();
                final machineTotal = machineLogs.fold<double>(
                  0.0,
                  (sum, log) => sum + log.totalPrice,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.minor_crash_outlined),
                    title: Text(machine.name),
                    subtitle: Text(
                      '${CurrencyFormatter.format(machine.pricePerHour)}/ساعه • الإجمالي: ${CurrencyFormatter.format(machineTotal)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkLogScreen(
                            projectId: projectId,
                            machineId: machineId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, BuildContext context,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : null,
                ),
          ),
          Text(
            CurrencyFormatter.format(amount),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: isBold ? FontWeight.bold : null,
                ),
          ),
        ],
      ),
    );
  }
}
