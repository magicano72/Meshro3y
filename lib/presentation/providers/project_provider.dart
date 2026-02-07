import 'package:Meshro3y/data/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/project_model.dart';
import 'providers.dart';

class ProjectNotifier extends StateNotifier<List<ProjectModel>> {
  final Repository _repository;

  ProjectNotifier(this._repository) : super([]) {
    _loadProjects();
  }

  void _loadProjects() {
    state = _repository.getAllProjects();
  }

  Future<void> addProject(
      String id, String name, List<String> machineIds) async {
    final project = ProjectModel(
      id: id,
      name: name,
      machineIds: machineIds,
      createdAt: DateTime.now(),
    );
    await _repository.saveProject(project);
    _loadProjects();
  }

  Future<void> updateProject(
      String id, String name, List<String> machineIds) async {
    final project = _repository.getProject(id);
    if (project != null) {
      final updated = project.copyWith(name: name, machineIds: machineIds);
      await _repository.saveProject(updated);
      _loadProjects();
    }
  }

  Future<void> deleteProject(String id) async {
    await _repository.deleteProject(id);
    _loadProjects();
  }

  Future<void> addMachineToProject(String projectId, String machineId) async {
    final project = _repository.getProject(projectId);
    if (project != null && !project.machineIds.contains(machineId)) {
      final updatedMachineIds = [...project.machineIds, machineId];
      final updated = project.copyWith(machineIds: updatedMachineIds);
      await _repository.saveProject(updated);
      _loadProjects();
    }
  }

  ProjectModel? getProjectById(String id) {
    return _repository.getProject(id);
  }
}

final projectProvider =
    StateNotifierProvider<ProjectNotifier, List<ProjectModel>>((ref) {
  final repository = ref.watch(repositoryProvider);
  return ProjectNotifier(repository);
});
