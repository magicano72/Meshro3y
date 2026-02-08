import 'package:Meshro3y/data/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/owner_model.dart';
import 'providers.dart';

class OwnerNotifier extends StateNotifier<OwnerModel?> {
  final Repository _repository;

  OwnerNotifier(this._repository) : super(null) {
    _loadOwner();
  }

  void _loadOwner() {
    state = _repository.getOwner();
  }

  Future<void> saveOwner(String name, String phone, String id,
      {String? avatarPath}) async {
    final owner = OwnerModel(
      id: id,
      name: name,
      phone: phone,
      avatarPath: avatarPath,
    );
    await _repository.saveOwner(owner);
    state = owner;
  }

  Future<void> updateOwner(String name, String phone,
      {String? avatarPath}) async {
    if (state != null) {
      final updatedOwner = state!.copyWith(
        name: name,
        phone: phone,
        avatarPath: avatarPath,
      );
      await _repository.saveOwner(updatedOwner);
      state = updatedOwner;
    }
  }
}

final ownerProvider = StateNotifierProvider<OwnerNotifier, OwnerModel?>((ref) {
  final repository = ref.watch(repositoryProvider);
  return OwnerNotifier(repository);
});
