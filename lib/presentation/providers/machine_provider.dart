import 'package:Meshro3y/data/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/machine_model.dart';
import 'providers.dart';

class MachineNotifier extends StateNotifier<List<MachineModel>> {
  final Repository _repository;

  MachineNotifier(this._repository) : super([]) {
    _loadMachines();
  }

  void _loadMachines() {
    state = _repository.getAllMachines();
  }

  Future<void> addMachine(String id, String name, double pricePerHour) async {
    final machine = MachineModel(
      id: id,
      name: name,
      pricePerHour: pricePerHour,
    );
    await _repository.saveMachine(machine);
    _loadMachines();
  }

  Future<void> updateMachine(
      String id, String name, double pricePerHour) async {
    final machine = _repository.getMachine(id);
    if (machine != null) {
      final updated = machine.copyWith(name: name, pricePerHour: pricePerHour);
      await _repository.saveMachine(updated);
      _loadMachines();
    }
  }

  Future<void> deleteMachine(String id) async {
    await _repository.deleteMachine(id);
    _loadMachines();
  }

  MachineModel? getMachineById(String id) {
    return _repository.getMachine(id);
  }
}

final machineProvider =
    StateNotifierProvider<MachineNotifier, List<MachineModel>>((ref) {
  final repository = ref.watch(repositoryProvider);
  return MachineNotifier(repository);
});
