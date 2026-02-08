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

  @HiveField(3)
  final String? avatarPath;

  OwnerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarPath,
  });

  OwnerModel copyWith({
    String? name,
    String? phone,
    String? avatarPath,
  }) {
    return OwnerModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
