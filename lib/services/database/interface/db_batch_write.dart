import '../../utils/service_action.dart';

abstract interface class DbBatch {
  /// commits all writes
  Future<ServiceAction> commit();

  ServiceAction update({
    required String id,
    required Map<String, dynamic> data,
  });

  ServiceAction delete({
    required String id,
  });

  ServiceAction setAtList(
    String itemId, {
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  });

  ServiceAction updateAtList(
    String itemId, {
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  });
}
