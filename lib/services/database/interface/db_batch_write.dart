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
}
