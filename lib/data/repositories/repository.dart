import '../datasources/local_data_source.dart';
import '../models/machine_model.dart';
import '../models/owner_model.dart';
import '../models/payment_model.dart';
import '../models/project_model.dart';
import '../models/work_log_model.dart';

class Repository {
  final LocalDataSource _localDataSource;

  Repository(this._localDataSource);

  // Owner
  Future<void> saveOwner(OwnerModel owner) => _localDataSource.saveOwner(owner);
  OwnerModel? getOwner() => _localDataSource.getOwner();

  // Machine
  Future<void> saveMachine(MachineModel machine) =>
      _localDataSource.saveMachine(machine);
  Future<void> deleteMachine(String id) => _localDataSource.deleteMachine(id);
  List<MachineModel> getAllMachines() => _localDataSource.getAllMachines();
  MachineModel? getMachine(String id) => _localDataSource.getMachine(id);

  // Project
  Future<void> saveProject(ProjectModel project) =>
      _localDataSource.saveProject(project);
  Future<void> deleteProject(String id) => _localDataSource.deleteProject(id);
  List<ProjectModel> getAllProjects() => _localDataSource.getAllProjects();
  ProjectModel? getProject(String id) => _localDataSource.getProject(id);

  // WorkLog
  Future<void> saveWorkLog(WorkLogModel workLog) =>
      _localDataSource.saveWorkLog(workLog);
  Future<void> deleteWorkLog(String id) => _localDataSource.deleteWorkLog(id);
  List<WorkLogModel> getWorkLogsForProjectAndMachine(
          String projectId, String machineId) =>
      _localDataSource.getWorkLogsForProjectAndMachine(projectId, machineId);
  List<WorkLogModel> getWorkLogsForProject(String projectId) =>
      _localDataSource.getWorkLogsForProject(projectId);

  // Payment
  Future<void> savePayment(PaymentModel payment) =>
      _localDataSource.savePayment(payment);
  Future<void> deletePayment(String id) => _localDataSource.deletePayment(id);
  List<PaymentModel> getPaymentsForProject(String projectId) =>
      _localDataSource.getPaymentsForProject(projectId);
}
