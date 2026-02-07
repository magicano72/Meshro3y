import 'package:Meshro3y/data/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/payment_model.dart';
import 'providers.dart';

class PaymentNotifier extends StateNotifier<List<PaymentModel>> {
  final Repository _repository;
  final String projectId;

  PaymentNotifier(this._repository, this.projectId) : super([]) {
    _loadPayments();
  }

  void _loadPayments() {
    state = _repository.getPaymentsForProject(projectId);
  }

  Future<void> addPayment(String id, double amount, DateTime date) async {
    final payment = PaymentModel(
      id: id,
      projectId: projectId,
      amount: amount,
      date: date,
    );
    await _repository.savePayment(payment);
    _loadPayments();
  }

  Future<void> updatePayment(String id, double amount, DateTime date) async {
    final payments = state.where((payment) => payment.id == id).toList();
    if (payments.isNotEmpty) {
      final payment = payments.first;
      final updated = payment.copyWith(amount: amount, date: date);
      await _repository.savePayment(updated);
      _loadPayments();
    }
  }

  Future<void> deletePayment(String id) async {
    await _repository.deletePayment(id);
    _loadPayments();
  }

  double getTotalPaid() {
    return state.fold(0.0, (sum, payment) => sum + payment.amount);
  }
}

final paymentProvider =
    StateNotifierProvider.family<PaymentNotifier, List<PaymentModel>, String>(
        (ref, projectId) {
  final repository = ref.watch(repositoryProvider);
  return PaymentNotifier(repository, projectId);
});
