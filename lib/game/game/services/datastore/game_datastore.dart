import 'system_datastore.dart';

/// TODO: implement
class GameDatastore {
  final SystemDatastore _systemDatastore = SystemDatastore();

  GameDatastore();

  /// getters
  SystemDatastore get systemDatastore => _systemDatastore;
}
