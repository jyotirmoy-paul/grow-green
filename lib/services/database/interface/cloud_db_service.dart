import '../../utils/service_action.dart';
import 'db_batch_write.dart';

abstract interface class CloudDbService {
  Future<ServiceAction> initialize({
    required String path,
  });

  Future<ServiceAction> connect();
  Future<ServiceAction> disconnect();

  DbBatch createBatch();

  Future<ServiceAction> update({
    required String id,
    required Map<String, dynamic> data,
  });

  Future<(ServiceAction, Map<String, dynamic>)> get({
    required String id,
  });

  Future<ServiceAction> delete({
    required String id,
  });

  Future<(ServiceAction, List<Map<String, dynamic>>)> getList({
    required String id,
    required String listId,
  });
}
