import 'package:hive/hive.dart';

part 'machine_model.g.dart';

@HiveType(typeId: 1)
class MachineModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double pricePerHour;

  MachineModel({
    required this.id,
    required this.name,
    required this.pricePerHour,
  });

  MachineModel copyWith({
    String? name,
    double? pricePerHour,
  }) {
    return MachineModel(
      id: id,
      name: name ?? this.name,
      pricePerHour: pricePerHour ?? this.pricePerHour,
    );
  }
}
