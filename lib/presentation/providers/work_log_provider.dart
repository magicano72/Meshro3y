import 'package:Meshro3y/data/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/project_model.dart';
import '../../data/models/work_log_model.dart';
import 'project_provider.dart';
import 'providers.dart';

class WorkLogNotifier extends StateNotifier<List<WorkLogModel>> {
  final Repository _repository;
  final String projectId;
  final String machineId;

  WorkLogNotifier(this._repository, this.projectId, this.machineId)
      : super([]) {
    _loadWorkLogs();
  }

  void _loadWorkLogs() {
    final logs =
        _repository.getWorkLogsForProjectAndMachine(projectId, machineId);
    state = List<WorkLogModel>.from(logs);
  }

  void reload() {
    _loadWorkLogs();
  }

  Future<void> addWorkLog(
      String id, DateTime date, double hours, double totalPrice) async {
    final workLog = WorkLogModel(
      id: id,
      projectId: projectId,
      machineId: machineId,
      date: date,
      hours: hours,
      totalPrice: totalPrice,
    );
    await _repository.saveWorkLog(workLog);
    _loadWorkLogs();
  }

  Future<void> updateWorkLog(
      String id, DateTime date, double hours, double totalPrice) async {
    final workLogs = state.where((log) => log.id == id).toList();
    if (workLogs.isNotEmpty) {
      final workLog = workLogs.first;
      final updated = workLog.copyWith(
        date: date,
        hours: hours,
        totalPrice: totalPrice,
      );
      await _repository.saveWorkLog(updated);
      _loadWorkLogs();
    }
  }

  Future<void> deleteWorkLog(String id) async {
    await _repository.deleteWorkLog(id);
    _loadWorkLogs();
  }

  double getTotalHours() {
    return state.fold(0.0, (sum, log) => sum + log.hours);
  }

  double getTotalCost() {
    return state.fold(0.0, (sum, log) => sum + log.totalPrice);
  }
}

class WorkLogParams {
  final String projectId;
  final String machineId;

  const WorkLogParams({
    required this.projectId,
    required this.machineId,
  });

  @override
  bool operator ==(Object other) {
    return other is WorkLogParams &&
        other.projectId == projectId &&
        other.machineId == machineId;
  }

  @override
  int get hashCode => Object.hash(projectId, machineId);
}

final workLogProvider = StateNotifierProvider.family<WorkLogNotifier,
    List<WorkLogModel>, WorkLogParams>((ref, params) {
  final repository = ref.watch(repositoryProvider);
  final notifier = WorkLogNotifier(
    repository,
    params.projectId,
    params.machineId,
  );
  final box = Hive.box<WorkLogModel>(AppConstants.workLogBox);
  final subscription = box.watch().listen((_) {
    notifier.reload();
  });
  ref.onDispose(subscription.cancel);
  return notifier;
});

// Provider to get all work logs for a project
final projectWorkLogsProvider =
    Provider.family<List<WorkLogModel>, String>((ref, projectId) {
  final allProjects = ref.watch(projectProvider);

  // Get the project to find its machine IDs
  ProjectModel? project;
  try {
    project = allProjects.firstWhere((p) => p.id == projectId);
  } catch (e) {
    return [];
  }

  if (project.machineIds.isEmpty) {
    return [];
  }

  // Watch all work log providers for each machine in this project
  final allLogs = <WorkLogModel>[];
  for (final machineId in project.machineIds) {
    final logs = ref.watch(workLogProvider(
      WorkLogParams(projectId: projectId, machineId: machineId),
    ));
    allLogs.addAll(logs);
  }

  return allLogs;
});
