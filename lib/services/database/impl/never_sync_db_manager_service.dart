part of '../database_service_factory.dart';

class _NeverSyncDbManagerService implements DbManagerService {
  final CloudDbService cloudDbService;

  static const tag = "_NeverSyncDbManagerService";

  _NeverSyncDbManagerService()
      : cloudDbService = CloudDatabaseServiceFactory.build(SupportedCloudDatabaseService.firebase);

  @override
  Future<ServiceAction> addToListAt(String itemId,
      {required String id, required String listId, required Map<String, dynamic> data}) {
    return mockSuccess();
  }

  @override
  Future<ServiceAction> configure({required User user, Duration? syncInterval}) async {
    /// initialize the cloud db service
    final status = await cloudDbService.initialize(path: user.id);
    if (status == ServiceAction.failure) return status;

    return status;
  }

  @override
  Future<ServiceAction> delete({required String id}) {
    return mockSuccess();
  }

  @override
  Future<(ServiceAction, Map<String, dynamic>)> get({required String id}) {
    Log.d('$tag: get(id: $id) is invoked');
    return cloudDbService.get(id: id);
  }

  @override
  Future<(ServiceAction, List<Map<String, dynamic>>)> getList({required String id, required String listId}) {
    return cloudDbService.getList(id: id, listId: listId);
  }

  @override
  Future<ServiceAction> sync() {
    return mockSuccess();
  }

  @override
  Future<ServiceAction> update({required String id, required Map<String, dynamic> data}) {
    return mockSuccess();
  }

  @override
  Future<ServiceAction> updateListItemAt(
    String itemId, {
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  }) {
    return mockSuccess();
  }

  Future<ServiceAction> mockSuccess() async {
    return ServiceAction.success;
  }
}
