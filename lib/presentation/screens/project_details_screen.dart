import 'package:Meshro3y/data/models/project_model.dart';
import 'package:Meshro3y/presentation/utils/smooth_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  'selectMachines'.tr,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableMachines.length,
              itemBuilder: (context, index) {
                final machine = availableMachines[index];
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.construction,
                        size: 20,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    title: Text(
                      machine.name,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${CurrencyFormatter.format(machine.pricePerHour)}/hour',
                      style: TextStyle(fontSize: isTablet ? 14 : 12),
                    ),
                    onTap: () {
                      ref.read(projectProvider.notifier).addMachineToProject(
                            projectId,
                            machine.id,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('machineAdded'.tr)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
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
                Icons.folder_open,
                color: Theme.of(context).colorScheme.primary,
                size: isTablet ? 28 : 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                project.name,
                style: TextStyle(
                  fontSize: isTablet ? 22 : 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  SmoothTransitions.slideTransition(
                    PdfInvoiceScreen(projectId: projectId),
                  ),
                );
              },
              label: Text(
                'invoice'.tr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Financial Summary Card
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
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
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
                              Icons.trending_up,
                              color: Theme.of(context).colorScheme.primary,
                              size: isTablet ? 28 : 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'financialSummary'.tr,
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      _buildSummaryRow(
                        'totalCost'.tr,
                        totalCost,
                        context,
                        isTablet,
                        icon: Icons.attach_money,
                      ),
                      SizedBox(height: isTablet ? 12 : 10),
                      _buildSummaryRow(
                        'totalPaid'.tr,
                        totalPaid,
                        context,
                        isTablet,
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icons.check_circle,
                      ),
                      SizedBox(height: isTablet ? 12 : 10),
                      Container(
                        padding: EdgeInsets.all(isTablet ? 12 : 10),
                        decoration: BoxDecoration(
                          color: remaining > 0
                              ? Theme.of(context).colorScheme.errorContainer
                              : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _buildSummaryRow(
                          'remaining'.tr,
                          remaining,
                          context,
                          isTablet,
                          color: remaining > 0
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                          isBold: true,
                          icon: remaining > 0 ? Icons.error : Icons.done_all,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: isTablet ? 32 : 24),

            // Payments Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        size: isTablet ? 24 : 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'payments'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      SmoothTransitions.slideTransition(
                        PaymentsScreen(projectId: projectId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right),
                  label: Text('View All'.tr),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 12),

            // Machines Section
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
                    const SizedBox(width: 12),
                    Text(
                      'machines'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
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
                    onPressed: () => _showAddMachineDialog(context, ref),
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 12),
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

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).push(
                          SmoothTransitions.slideTransition(
                            WorkLogScreen(
                              projectId: projectId,
                              machineId: machineId,
                            ),
                          ),
                        );
                      },
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              borderRadius: BorderRadius.circular(10),
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '${CurrencyFormatter.format(machine.pricePerHour)}/hour',
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Total: ${CurrencyFormatter.format(machineTotal)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount,
    BuildContext context,
    bool isTablet, {
    Color? color,
    bool isBold = false,
    IconData? icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  icon,
                  size: 20,
                  color:
                      color ?? Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
