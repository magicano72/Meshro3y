import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 2)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> machineIds;

  @HiveField(3)
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.name,
    required this.machineIds,
    required this.createdAt,
  });

  ProjectModel copyWith({
    String? name,
    List<String>? machineIds,
  }) {
    return ProjectModel(
      id: id,
      name: name ?? this.name,
      machineIds: machineIds ?? this.machineIds,
      createdAt: createdAt,
    );
  }
}
