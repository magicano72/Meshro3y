import 'package:Meshro3y/data/datasources/local_data_source.dart';
import 'package:Meshro3y/data/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Source Provider
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

// Repository Provider
final repositoryProvider = Provider<Repository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return Repository(localDataSource);
});
