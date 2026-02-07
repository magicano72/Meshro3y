import 'package:hive/hive.dart';

part 'owner_model.g.dart';

@HiveType(typeId: 0)
class OwnerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  OwnerModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  OwnerModel copyWith({
    String? name,
    String? phone,
  }) {
    return OwnerModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}
