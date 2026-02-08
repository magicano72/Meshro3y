import 'dart:io';

import 'package:Meshro3y/data/models/machine_model.dart';
import 'package:Meshro3y/data/models/project_model.dart';
import 'package:Meshro3y/data/models/work_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/formatters.dart';
import '../providers/machine_provider.dart';
import '../providers/owner_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/project_provider.dart';
import '../providers/work_log_provider.dart';
import '../services/pdf_service.dart';

class PdfInvoiceScreen extends ConsumerStatefulWidget {
  final String projectId;

  const PdfInvoiceScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<PdfInvoiceScreen> createState() => _PdfInvoiceScreenState();
}

class _PdfInvoiceScreenState extends ConsumerState<PdfInvoiceScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });
    }
  }

  Future<void> _generateAndPreviewPdf() async {
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('selectDateRange'.tr)),
      );
      return;
    }

    final owner = ref.read(ownerProvider);
    final projects = ref.read(projectProvider);
    ProjectModel? project;
    try {
      project = projects.firstWhere((p) => p.id == widget.projectId);
    } catch (e) {
      project = null;
    }
    final allWorkLogs = ref.read(projectWorkLogsProvider(widget.projectId));
    final payments = ref.read(paymentProvider(widget.projectId));

    if (owner == null || owner.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('missingOwnerInfo'.tr)),
      );
      return;
    }

    if (project == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('projectNotFound'.tr)),
      );
      return;
    }

    // Filter work logs by date range
    final filteredLogs = allWorkLogs
        .where((log) =>
            log.date.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
            log.date.isBefore(_toDate!.add(const Duration(days: 1))))
        .toList();

    if (filteredLogs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('noWorkLogs'.tr)),
      );
      return;
    }

    // Group logs by machine
    final Map<String, List<WorkLogModel>> logsByMachine = {};
    for (final log in filteredLogs) {
      logsByMachine.putIfAbsent(log.machineId, () => []).add(log);
    }

    // Get machine details
    final machineDetails = <String, MachineModel>{};
    for (final machineId in logsByMachine.keys) {
      final machine =
          ref.read(machineProvider.notifier).getMachineById(machineId);
      if (machine != null) {
        machineDetails[machineId] = machine;
      }
    }

    final pdfService = PdfService();
    final pdfBytes = await pdfService.generateInvoice(
      owner: owner,
      project: project,
      logsByMachine: logsByMachine,
      machineDetails: machineDetails,
      payments: payments,
      fromDate: _fromDate!,
      toDate: _toDate!,
    );

    // Preview PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: '${project.name}_Invoice.pdf',
    );
  }

  Future<void> _downloadPdf() async {
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('selectDateRange'.tr)),
      );
      return;
    }

    final owner = ref.read(ownerProvider);
    final projects = ref.read(projectProvider);
    ProjectModel? project;
    try {
      project = projects.firstWhere((p) => p.id == widget.projectId);
    } catch (e) {
      project = null;
    }
    final allWorkLogs = ref.read(projectWorkLogsProvider(widget.projectId));
    final payments = ref.read(paymentProvider(widget.projectId));

    if (owner == null || project == null) return;

    final filteredLogs = allWorkLogs
        .where((log) =>
            log.date.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
            log.date.isBefore(_toDate!.add(const Duration(days: 1))))
        .toList();

    if (filteredLogs.isEmpty) return;

    final Map<String, List<WorkLogModel>> logsByMachine = {};
    for (final log in filteredLogs) {
      logsByMachine.putIfAbsent(log.machineId, () => []).add(log);
    }

    final machineDetails = <String, MachineModel>{};
    for (final machineId in logsByMachine.keys) {
      final machine =
          ref.read(machineProvider.notifier).getMachineById(machineId);
      if (machine != null) {
        machineDetails[machineId] = machine;
      }
    }

    final pdfService = PdfService();
    final pdfBytes = await pdfService.generateInvoice(
      owner: owner,
      project: project,
      logsByMachine: logsByMachine,
      machineDetails: machineDetails,
      payments: payments,
      fromDate: _fromDate!,
      toDate: _toDate!,
    );

    // Save to device
    final output = await getApplicationDocumentsDirectory();
    final file = File(
        '${output.path}/${project.name}_Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(pdfBytes);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to ${file.path}')),
    );
  }

  Future<void> _sharePdf() async {
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('selectDateRange'.tr)),
      );
      return;
    }

    final owner = ref.read(ownerProvider);
    final projects = ref.read(projectProvider);
    ProjectModel? project;
    try {
      project = projects.firstWhere((p) => p.id == widget.projectId);
    } catch (e) {
      project = null;
    }
    final allWorkLogs = ref.read(projectWorkLogsProvider(widget.projectId));
    final payments = ref.read(paymentProvider(widget.projectId));

    if (owner == null || project == null) return;

    final filteredLogs = allWorkLogs
        .where((log) =>
            log.date.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
            log.date.isBefore(_toDate!.add(const Duration(days: 1))))
        .toList();

    if (filteredLogs.isEmpty) return;

    final Map<String, List<WorkLogModel>> logsByMachine = {};
    for (final log in filteredLogs) {
      logsByMachine.putIfAbsent(log.machineId, () => []).add(log);
    }

    final machineDetails = <String, MachineModel>{};
    for (final machineId in logsByMachine.keys) {
      final machine =
          ref.read(machineProvider.notifier).getMachineById(machineId);
      if (machine != null) {
        machineDetails[machineId] = machine;
      }
    }

    final pdfService = PdfService();
    final pdfBytes = await pdfService.generateInvoice(
      owner: owner,
      project: project,
      logsByMachine: logsByMachine,
      machineDetails: machineDetails,
      payments: payments,
      fromDate: _fromDate!,
      toDate: _toDate!,
    );

    // Save temporarily to share
    final output = await getApplicationDocumentsDirectory();
    final fileName =
        '${project.name}_Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(pdfBytes);

    if (!mounted) return;

    // Share the PDF file
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Invoice for ${project.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final project =
        ref.watch(projectProvider.notifier).getProjectById(widget.projectId);

    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: Text('generateInvoice'.tr)),
        body: Center(child: Text('projectNotFound'.tr)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('generateInvoice'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'selectDateRange'.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _selectDateRange,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _fromDate != null && _toDate != null
                            ? '${DateFormatter.formatShort(_fromDate!)} - ${DateFormatter.formatShort(_toDate!)}'
                            : 'selectDateRange'.tr,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project: ${project.name}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'invoiceIncludes'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('• ${'ownerInfo'.tr}'),
                    Text('• ${'projectDetails'.tr}'),
                    Text('• ${'machineBreakdown'.tr}'),
                    Text('• ${'dailyLogs'.tr}'),
                    Text('• ${'totalHoursAndCost'.tr}'),
                    Text('• ${'paymentDetails'.tr}'),
                    Text('• ${'remainingBalance'.tr}'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _generateAndPreviewPdf,
              icon: const Icon(Icons.preview),
              label: Text('previewPdf'.tr),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _downloadPdf,
              icon: const Icon(Icons.download),
              label: Text('downloadPdf'.tr),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _sharePdf,
              icon: const Icon(Icons.share),
              label: Text('sharePdf'.tr),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
