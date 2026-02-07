import 'package:hive/hive.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 4)
class PaymentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  PaymentModel({
    required this.id,
    required this.projectId,
    required this.amount,
    required this.date,
  });

  PaymentModel copyWith({
    double? amount,
    DateTime? date,
  }) {
    return PaymentModel(
      id: id,
      projectId: projectId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
