import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/formatters.dart';
import '../../data/models/machine_model.dart';
import '../../data/models/owner_model.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/project_model.dart';
import '../../data/models/work_log_model.dart';

class PdfService {
  Future<Uint8List> generateInvoice({
    required OwnerModel owner,
    required ProjectModel project,
    required Map<String, List<WorkLogModel>> logsByMachine,
    required Map<String, MachineModel> machineDetails,
    required List<PaymentModel> payments,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final pdf = pw.Document();

    // Calculate totals
    double grandTotalHours = 0;
    double grandTotalCost = 0;

    for (final logs in logsByMachine.values) {
      for (final log in logs) {
        grandTotalHours += log.hours;
        grandTotalCost += log.totalPrice;
      }
    }

    final totalPaid = payments.fold<double>(0.0, (sum, p) => sum + p.amount);
    final remaining = grandTotalCost - totalPaid;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          _buildHeader(owner, project, fromDate, toDate),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Machine-wise breakdown
          _buildMachineBreakdown(logsByMachine, machineDetails),
          pw.SizedBox(height: 20),

          // Summary
          _buildSummary(
            grandTotalHours,
            grandTotalCost,
            totalPaid,
            remaining,
          ),
          pw.SizedBox(height: 20),

          // Payments
          if (payments.isNotEmpty) ...[
            pw.Divider(),
            pw.SizedBox(height: 20),
            _buildPaymentSection(payments),
          ],
        ],
        footer: (context) => _buildFooter(context),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(
    OwnerModel owner,
    ProjectModel project,
    DateTime fromDate,
    DateTime toDate,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'INVOICE',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'From:',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(owner.name, style: const pw.TextStyle(fontSize: 12)),
                pw.Text(owner.phone, style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Project:',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(project.name, style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Period:',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.Text(
                  '${DateFormatter.formatShort(fromDate)} - ${DateFormatter.formatShort(toDate)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildMachineBreakdown(
    Map<String, List<WorkLogModel>> logsByMachine,
    Map<String, MachineModel> machineDetails,
  ) {
    final List<pw.Widget> widgets = [];

    for (final entry in logsByMachine.entries) {
      final machineId = entry.key;
      final logs = entry.value;
      final machine = machineDetails[machineId];

      if (machine == null) continue;

      // Sort logs by date
      final sortedLogs = List<WorkLogModel>.from(logs)
        ..sort((a, b) => a.date.compareTo(b.date));

      final machineTotalHours =
          logs.fold<double>(0.0, (sum, log) => sum + log.hours);
      final machineTotalCost =
          logs.fold<double>(0.0, (sum, log) => sum + log.totalPrice);

      widgets.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              machine.name,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Rate: ${CurrencyFormatter.format(machine.pricePerHour)}/hour',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                // Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildTableCell('Date', isHeader: true),
                    _buildTableCell('Hours', isHeader: true),
                    _buildTableCell('Cost', isHeader: true),
                  ],
                ),
                // Data rows
                ...sortedLogs.map((log) => pw.TableRow(
                      children: [
                        _buildTableCell(DateFormatter.formatShort(log.date)),
                        _buildTableCell(log.hours.toStringAsFixed(1)),
                        _buildTableCell(
                            CurrencyFormatter.format(log.totalPrice)),
                      ],
                    )),
                // Total row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    _buildTableCell('Total', isHeader: true),
                    _buildTableCell(machineTotalHours.toStringAsFixed(1),
                        isHeader: true),
                    _buildTableCell(CurrencyFormatter.format(machineTotalCost),
                        isHeader: true),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
          ],
        ),
      );
    }

    return pw.Column(children: widgets);
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : null,
        ),
      ),
    );
  }

  pw.Widget _buildSummary(
    double totalHours,
    double totalCost,
    double totalPaid,
    double remaining,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          _buildSummaryRow('Total Hours:', totalHours.toStringAsFixed(1)),
          pw.SizedBox(height: 8),
          _buildSummaryRow('Total Cost:', CurrencyFormatter.format(totalCost)),
          pw.SizedBox(height: 8),
          _buildSummaryRow('Total Paid:', CurrencyFormatter.format(totalPaid)),
          pw.Divider(),
          _buildSummaryRow(
            'Balance Due:',
            CurrencyFormatter.format(remaining),
            isBold: true,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryRow(String label, String value,
      {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: isBold ? pw.FontWeight.bold : null,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: isBold ? pw.FontWeight.bold : null,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPaymentSection(List<PaymentModel> payments) {
    final sortedPayments = List<PaymentModel>.from(payments)
      ..sort((a, b) => a.date.compareTo(b.date));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Payment History',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Date', isHeader: true),
                _buildTableCell('Amount', isHeader: true),
              ],
            ),
            ...sortedPayments.map((payment) => pw.TableRow(
                  children: [
                    _buildTableCell(DateFormatter.formatShort(payment.date)),
                    _buildTableCell(CurrencyFormatter.format(payment.amount)),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.Text(
          'Generated on ${DateFormatter.format(DateTime.now())} - Page ${context.pageNumber} of ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        ),
      ],
    );
  }
}
