import 'package:Meshro3y/data/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/formatters.dart';
import '../providers/payment_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/empty_state.dart';

class PaymentsScreen extends ConsumerWidget {
  final String projectId;

  const PaymentsScreen({
    super.key,
    required this.projectId,
  });

  void _showPaymentDialog(BuildContext context, WidgetRef ref,
      {String? paymentId}) {
    final payments = ref.read(paymentProvider(projectId));
    final payment = paymentId != null
        ? payments.firstWhere((p) => p.id == paymentId)
        : null;

    final amountController = TextEditingController(
      text: payment?.amount.toString() ?? '',
    );
    final dateController = TextEditingController(
      text: payment != null ? DateFormatter.formatShort(payment.date) : '',
    );

    DateTime selectedDate = payment?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(payment == null ? 'addPayment'.tr : 'editPayment'.tr),
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
              label: 'amount'.tr,
              controller: amountController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.attach_money,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('pleaseEnterAmount'.tr)),
                );
                return;
              }

              final amount = double.tryParse(amountController.text.trim());
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('invalidAmount'.tr)),
                );
                return;
              }

              if (payment == null) {
                ref.read(paymentProvider(projectId).notifier).addPayment(
                      const Uuid().v4(),
                      amount,
                      selectedDate,
                    );
              } else {
                ref.read(paymentProvider(projectId).notifier).updatePayment(
                      payment.id,
                      amount,
                      selectedDate,
                    );
              }

              Navigator.pop(context);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  void _deletePayment(
      BuildContext context, WidgetRef ref, String id, DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('deletePayment'.tr),
        content: Text('${'deleteConfirm'.tr} ${DateFormatter.format(date)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(paymentProvider(projectId).notifier).deletePayment(id);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentProvider(projectId));

    // Sort by date descending
    final sortedPayments = List<PaymentModel>.from(payments)
      ..sort((a, b) => b.date.compareTo(a.date));

    final totalPaid = payments.fold<double>(
      0.0,
      (sum, payment) => sum + payment.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('payments'.tr),
      ),
      body: Column(
        children: [
          // Total Paid Card
          Card(
            margin: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'totalPayments'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    CurrencyFormatter.format(totalPaid),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Payments List
          Expanded(
            child: payments.isEmpty
                ? EmptyState(
                    icon: Icons.payment,
                    message: 'noPayments'.tr,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    itemCount: sortedPayments.length,
                    itemBuilder: (context, index) {
                      final payment = sortedPayments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.payment),
                          ),
                          title: Text(DateFormatter.format(payment.date)),
                          subtitle: Text('Payment #${index + 1}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CurrencyFormatter.format(payment.amount),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
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
                                    _showPaymentDialog(context, ref,
                                        paymentId: payment.id);
                                  } else if (value == 'delete') {
                                    _deletePayment(
                                        context, ref, payment.id, payment.date);
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
        onPressed: () => _showPaymentDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
