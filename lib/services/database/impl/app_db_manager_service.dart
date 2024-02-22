part of '../database_service_factory.dart';

class _IntervalSyncDbManagerService implements DbManagerService {
  static const tag = '_IntervalSyncDbManagerService';
  static const maxSyncAttempts = 10;

  final CloudDbService cloudDbService;

  _IntervalSyncDbManagerService()
      : cloudDbService = CloudDatabaseServiceFactory.build(SupportedCloudDatabaseService.firebase);

  /// By default, we will have a sync interval of 10 seconds
  /// And it's configurable
  late Duration _syncInterval;

  /// Cache which initially records all operations
  late DbBatch _cache;

  /// Keeps track if data is being synced right this moment
  /// This is to avoid starting another sync when one is in progress
  final Lock lock = Lock();

  /// Cache which gets used if a syncing is in progress, and a modify request is placed
  DbBatch? _temporaryCache;

  Timer? _syncTimer;

  void _initTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer(_syncInterval, () {
      if (lock.locked) return;
      Log.i('$tag: timer sync initiated');
      sync();
    });
  }

  @override
  Future<ServiceAction> configure({
    Duration syncInterval = const Duration(seconds: 10),
    required User user,
  }) async {
    /// initialize the cloud db service
    final status = await cloudDbService.initialize(path: user.id);
    if (status == ServiceAction.failure) return status;

    _cache = cloudDbService.createBatch();

    _syncInterval = syncInterval;
    _initTimer();

    return status;
  }

  /// A force sync can be requested, this is necessary to immediately record important events
  /// instead of waiting for the interval sync
  @override
  Future<ServiceAction> sync() async {
    Log.d('$tag: sync() is invoked, lock status: ${lock.locked}');

    return lock.synchronized<ServiceAction>(() async {
      Log.i('$tag: starting to sync local cache to server');

      int syncAttempt = 1;
      late ServiceAction status;

      while (syncAttempt <= maxSyncAttempts) {
        Log.i('$tag: sync attempt: $syncAttempt/$maxSyncAttempts');
        status = await _cache.commit();
        if (status == ServiceAction.success) break;
        syncAttempt++;
      }

      if (status == ServiceAction.failure) {
        Log.e('$tag: syncing failed after retrying for $syncAttempt times');
        _cache = _temporaryCache ?? cloudDbService.createBatch();
        return ServiceAction.failure;
      }

      /// if sync succeeds
      Log.i('$tag: syncing was successful');

      /// once syncing is successfully completed, we can cancel the existing timer and start a new one
      /// this is done to avoid unnecessary immediate syncing
      _initTimer();

      /// create a new cache
      /// either from an existing temporary batch (if any modify request was made during syncing)
      /// or a fresh new batch!
      _cache = _temporaryCache ?? cloudDbService.createBatch();

      return ServiceAction.success;
    });
  }

  @override
  Future<(ServiceAction, Map<String, dynamic>)> get({required String id}) {
    Log.d('$tag: get(id: $id) is invoked');
    return cloudDbService.get(id: id);
  }

  @override
  Future<ServiceAction> set({required String id, required Map<String, dynamic> data}) async {
    Log.d('$tag: set(id: $id, data: $data) is invoked, lock status: ${lock.locked}');

    if (lock.locked) {
      _temporaryCache ??= cloudDbService.createBatch();
      _temporaryCache!.write(id: id, data: data);
    } else {
      _cache.write(id: id, data: data);
    }

    return ServiceAction.success;
  }

  @override
  Future<ServiceAction> delete({required String id}) async {
    Log.d('$tag: delete(id: $id) is invoked, lock status: ${lock.locked}');

    if (lock.locked) {
      _temporaryCache ??= cloudDbService.createBatch();
      _temporaryCache!.delete(id: id);
    } else {
      _cache.delete(id: id);
    }

    return ServiceAction.success;
  }
}
