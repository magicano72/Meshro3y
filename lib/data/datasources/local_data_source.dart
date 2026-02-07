import 'package:hive/hive.dart';
import '../models/machine_model.dart';
import '../models/owner_model.dart';
import '../models/payment_model.dart';
import '../models/project_model.dart';
import '../models/work_log_model.dart';
import '../../core/constants/app_constants.dart';

class LocalDataSource {
  // Owner Operations
  Future<void> saveOwner(OwnerModel owner) async {
    final box = Hive.box<OwnerModel>(AppConstants.ownerBox);
    await box.put(AppConstants.ownerKey, owner);
  }

  OwnerModel? getOwner() {
    final box = Hive.box<OwnerModel>(AppConstants.ownerBox);
    return box.get(AppConstants.ownerKey);
  }

  // Machine Operations
  Future<void> saveMachine(MachineModel machine) async {
    final box = Hive.box<MachineModel>(AppConstants.machineBox);
    await box.put(machine.id, machine);
  }

  Future<void> deleteMachine(String id) async {
    final box = Hive.box<MachineModel>(AppConstants.machineBox);
    await box.delete(id);
  }

  List<MachineModel> getAllMachines() {
    final box = Hive.box<MachineModel>(AppConstants.machineBox);
    return box.values.toList();
  }

  MachineModel? getMachine(String id) {
    final box = Hive.box<MachineModel>(AppConstants.machineBox);
    return box.get(id);
  }

  // Project Operations
  Future<void> saveProject(ProjectModel project) async {
    final box = Hive.box<ProjectModel>(AppConstants.projectBox);
    await box.put(project.id, project);
  }

  Future<void> deleteProject(String id) async {
    final box = Hive.box<ProjectModel>(AppConstants.projectBox);
    await box.delete(id);
  }

  List<ProjectModel> getAllProjects() {
    final box = Hive.box<ProjectModel>(AppConstants.projectBox);
    return box.values.toList();
  }

  ProjectModel? getProject(String id) {
    final box = Hive.box<ProjectModel>(AppConstants.projectBox);
    return box.get(id);
  }

  // WorkLog Operations
  Future<void> saveWorkLog(WorkLogModel workLog) async {
    final box = Hive.box<WorkLogModel>(AppConstants.workLogBox);
    await box.put(workLog.id, workLog);
  }

  Future<void> deleteWorkLog(String id) async {
    final box = Hive.box<WorkLogModel>(AppConstants.workLogBox);
    await box.delete(id);
  }

  List<WorkLogModel> getWorkLogsForProjectAndMachine(
      String projectId, String machineId) {
    final box = Hive.box<WorkLogModel>(AppConstants.workLogBox);
    return box.values
        .where((log) => log.projectId == projectId && log.machineId == machineId)
        .toList();
  }

  List<WorkLogModel> getWorkLogsForProject(String projectId) {
    final box = Hive.box<WorkLogModel>(AppConstants.workLogBox);
    return box.values.where((log) => log.projectId == projectId).toList();
  }

  // Payment Operations
  Future<void> savePayment(PaymentModel payment) async {
    final box = Hive.box<PaymentModel>(AppConstants.paymentBox);
    await box.put(payment.id, payment);
  }

  Future<void> deletePayment(String id) async {
    final box = Hive.box<PaymentModel>(AppConstants.paymentBox);
    await box.delete(id);
  }

  List<PaymentModel> getPaymentsForProject(String projectId) {
    final box = Hive.box<PaymentModel>(AppConstants.paymentBox);
    return box.values.where((payment) => payment.projectId == projectId).toList();
  }
}
