import 'package:Meshro3y/data/models/work_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/formatters.dart';
import '../providers/machine_provider.dart';
import '../providers/work_log_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/empty_state.dart';

class WorkLogScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String machineId;

  const WorkLogScreen({
    super.key,
    required this.projectId,
    required this.machineId,
  });

  @override
  ConsumerState<WorkLogScreen> createState() => _WorkLogScreenState();
}

class _WorkLogScreenState extends ConsumerState<WorkLogScreen> {
  void _showWorkLogDialog({String? workLogId}) {
    final workLogs = ref.read(workLogProvider(
      WorkLogParams(
        projectId: widget.projectId,
        machineId: widget.machineId,
      ),
    ));

    final workLog = workLogId != null
        ? workLogs.firstWhere((log) => log.id == workLogId)
        : null;

    final dateController = TextEditingController(
      text: workLog != null ? DateFormatter.formatShort(workLog.date) : '',
    );
    final hoursController = TextEditingController(
      text: workLog?.hours.toString() ?? '',
    );

    DateTime selectedDate = workLog?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(workLog == null ? 'addWorkLog'.tr : 'editWorkLog'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date'.tr,
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  selectedDate = date;
                  dateController.text = DateFormatter.formatShort(date);
                }
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Hours Worked'.tr,
              controller: hoursController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.access_time,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              if (hoursController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('pleaseEnterHours'.tr)),
                );
                return;
              }

              final hours = double.tryParse(hoursController.text.trim());
              if (hours == null || hours <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('invalidHours'.tr)),
                );
                return;
              }

              final machine = ref
                  .read(machineProvider.notifier)
                  .getMachineById(widget.machineId);
              if (machine == null) return;

              final totalPrice = hours * machine.pricePerHour;

              if (workLog == null) {
                await ref
                    .read(workLogProvider(
                      WorkLogParams(
                        projectId: widget.projectId,
                        machineId: widget.machineId,
                      ),
                    ).notifier)
                    .addWorkLog(
                      const Uuid().v4(),
                      selectedDate,
                      hours,
                      totalPrice,
                    );
              } else {
                await ref
                    .read(workLogProvider(
                      WorkLogParams(
                        projectId: widget.projectId,
                        machineId: widget.machineId,
                      ),
                    ).notifier)
                    .updateWorkLog(
                      workLog.id,
                      selectedDate,
                      hours,
                      totalPrice,
                    );
              }

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: Text('Save'.tr),
          ),
        ],
      ),
    );
  }

  void _deleteWorkLog(String id, DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('deleteWorkLog'.tr),
        content: Text('${'deleteConfirm'.tr} ${DateFormatter.format(date)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(workLogProvider(
                    WorkLogParams(
                      projectId: widget.projectId,
                      machineId: widget.machineId,
                    ),
                  ).notifier)
                  .deleteWorkLog(id);

              if (mounted) {
                Navigator.pop(context);
              }
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
    final machine =
        ref.watch(machineProvider.notifier).getMachineById(widget.machineId);
    final workLogs = ref.watch(workLogProvider(
      WorkLogParams(
        projectId: widget.projectId,
        machineId: widget.machineId,
      ),
    ));

    if (machine == null) {
      return Scaffold(
        appBar: AppBar(title: Text('machineNotFound'.tr)),
        body: Center(child: Text('machineNotFound'.tr)),
      );
    }

    // Sort by date descending
    final sortedLogs = List<WorkLogModel>.from(workLogs)
      ..sort((a, b) => b.date.compareTo(a.date));

    final totalHours =
        workLogs.fold<double>(0.0, (sum, log) => sum + log.hours);
    final totalCost =
        workLogs.fold<double>(0.0, (sum, log) => sum + log.totalPrice);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(machine.name),
            Text(
              '${CurrencyFormatter.format(machine.pricePerHour)}/ساعه',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'totalHours'.tr,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        totalHours.toStringAsFixed(1),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'totalCost'.tr,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        CurrencyFormatter.format(totalCost),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Work Logs List
          Expanded(
            child: workLogs.isEmpty
                ? EmptyState(
                    icon: Icons.access_time,
                    message: 'noWorkLogsYet'.tr,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    itemCount: sortedLogs.length,
                    itemBuilder: (context, index) {
                      final log = sortedLogs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(log.date.day.toString()),
                          ),
                          title: Text(DateFormatter.format(log.date)),
                          subtitle: Text('${log.hours} ساعه'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CurrencyFormatter.format(log.totalPrice),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('edit'.tr),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('delete'.tr,
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showWorkLogDialog(workLogId: log.id);
                                  } else if (value == 'delete') {
                                    _deleteWorkLog(log.id, log.date);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWorkLogDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
