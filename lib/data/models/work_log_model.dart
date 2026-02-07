import 'package:hive/hive.dart';

part 'work_log_model.g.dart';

@HiveType(typeId: 3)
class WorkLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final String machineId;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final double hours;

  @HiveField(5)
  final double totalPrice;

  WorkLogModel({
    required this.id,
    required this.projectId,
    required this.machineId,
    required this.date,
    required this.hours,
    required this.totalPrice,
  });

  WorkLogModel copyWith({
    DateTime? date,
    double? hours,
    double? totalPrice,
  }) {
    return WorkLogModel(
      id: id,
      projectId: projectId,
      machineId: machineId,
      date: date ?? this.date,
      hours: hours ?? this.hours,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
