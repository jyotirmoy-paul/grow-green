import '../../../models/auth/user.dart';
import '../../utils/service_action.dart';

/// The service which manages datastore writes, mainly responsible for the following items:
/// 1. Weather to write to local db or cloud db
/// 2. Periodic cloud db sync with local db
/// 3. Retry mechanism for failure of synchronization
///
/// Ideally, this is the service which the outside would should interact with
/// This is an interface, so that at later stage a different implementation
/// can be written for the manager service, and a easy swap would be possible
abstract interface class DbManagerService {
  Future<ServiceAction> configure({
    required User user,
    Duration syncInterval,
  });

  Future<ServiceAction> update({
    required String id,
    required Map<String, dynamic> data,
  });

  Future<(ServiceAction, Map<String, dynamic>)> get({
    required String id,
  });

  Future<(ServiceAction, List<Map<String, dynamic>>)> getList({
    required String id,
    required String listId,
  });

  Future<ServiceAction> addToListAt(
    String itemId, {
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  });

  Future<ServiceAction> updateListItemAt(
    String itemId, {
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  });

  Future<ServiceAction> delete({
    required String id,
  });

  Future<ServiceAction> sync();
}
