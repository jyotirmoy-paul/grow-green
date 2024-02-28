import '../../../../models/auth/user.dart';
import '../../../../services/database/database_service_factory.dart';
import '../../../../services/database/interface/db_manager_service.dart';
import '../../../../services/utils/service_action.dart';
import '../../world/components/land/components/farm/model/farm_state_model.dart';
import '../game_services/monetary/models/money_model.dart';

class GameDatastore {
  static const tag = 'GameDatastore';

  final DbManagerService _dbManagerService;

  /// Ids used in database
  static const _dateId = 'date';
  static const _dateTime = 'dateTime';

  static const _moneyId = 'money';
  static const _farmIdPrefix = 'farm-';
  String _generateFarmId(String farmId) => '$_farmIdPrefix$farmId';

  GameDatastore()
      : _dbManagerService = DbManagerServiceFactory.build(
          SupportedDbManagerService.intervalSync,
        );

  /// Initializes the game datastore
  Future<ServiceAction> initialize(User user) async {
    return _dbManagerService.configure(user: user);
  }

  /// date
  Future<ServiceAction> saveDate(DateTime dateTime) {
    return _dbManagerService.set(
      id: _dateId,
      data: {
        _dateTime: dateTime.toIso8601String(),
      },
    );
  }

  Future<DateTime> getDate() async {
    final (serviceAction, date) = await _dbManagerService.get(
      id: _dateId,
    );

    if (serviceAction == ServiceAction.failure) {
      throw Exception('$tag: getDate() failed');
    }

    final dateString = date[_dateTime] as String;
    return DateTime.parse(dateString);
  }

  /// money
  Future<ServiceAction> saveMoney(MoneyModel money) async {
    final status = await _dbManagerService.set(
      id: _moneyId,
      data: money.toJson(),
    );

    if (status == ServiceAction.failure) return status;

    /// saving money is an important action, we must immediately sync
    return _dbManagerService.sync();
  }

  Future<MoneyModel> getMoney() async {
    final (serviceAction, data) = await _dbManagerService.get(
      id: _moneyId,
    );

    if (serviceAction == ServiceAction.failure) {
      throw Exception('$tag: getMoney() failed');
    }

    return MoneyModel.fromJson(data);
  }

  /// farm
  Future<ServiceAction> saveFarmState(FarmStateModel farmState) async {
    final status = await _dbManagerService.set(
      id: _generateFarmId(farmState.farmId),
      data: farmState.toJson(),
    );

    if (status == ServiceAction.failure) return status;

    /// saving farm state is an important action, we must immediately sync
    return _dbManagerService.sync();
  }

  Future<FarmStateModel> getFarmState(String farmId) async {
    final (serviceAction, data) = await _dbManagerService.get(
      id: _generateFarmId(farmId),
    );

    if (serviceAction == ServiceAction.failure) {
      throw Exception('$tag: getFarmState() failed');
    }

    return FarmStateModel.fromJson(data);
  }

  /// TODO: Other db requirements!
  /// 1. Achievements
}
