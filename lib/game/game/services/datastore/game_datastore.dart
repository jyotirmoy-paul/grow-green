import 'package:flutter/foundation.dart';

import '../../../../models/auth/user.dart';
import '../../../../services/database/database_service_factory.dart';
import '../../../../services/database/interface/db_manager_service.dart';
import '../../../../services/utils/service_action.dart';
import '../../world/components/land/components/farm/model/farm_state_model.dart';
import '../../world/components/land/components/farm/model/harvest_model.dart';
import '../../world/components/land/components/farm/model/soil_health_model.dart';
import '../game_services/monetary/models/money_model.dart';

class GameDatastore {
  static const tag = 'GameDatastore';

  final DbManagerService _dbManagerService;

  /// Ids used in database
  static const _harvestModelsListId = 'harvestModels';
  static const _soilHealthModelsListId = 'soilHealthModels';

  static const _dateId = 'date';
  static const _dateTime = 'dateTime';

  static const _moneyId = 'money';
  static const _farmIdPrefix = 'farm-';
  String _farmId(String farmId) => '$_farmIdPrefix$farmId';

  GameDatastore()
      : _dbManagerService = DbManagerServiceFactory.build(
          SupportedDbManagerService.intervalSync,
        );

  /// Initializes the game datastore
  Future<ServiceAction> initialize(User user) async {
    return _dbManagerService.configure(
      user: user,
      syncInterval: const Duration(seconds: 20),
    );
  }

  /// date
  Future<ServiceAction> saveDate(DateTime dateTime) {
    return _dbManagerService.update(
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
    final status = await _dbManagerService.update(
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
    final status = await _dbManagerService.update(
      id: _farmId(farmState.farmId),
      data: farmState.toJson(),
    );

    if (status == ServiceAction.failure) return status;

    /// saving farm state is an important action, we must immediately sync
    return _dbManagerService.sync();
  }

  Future<FarmStateModel> getFarmState(String farmId) async {
    final (serviceAction, data) = await _dbManagerService.get(
      id: _farmId(farmId),
    );

    if (serviceAction == ServiceAction.failure) {
      throw Exception('$tag: getFarmState() failed');
    }

    return FarmStateModel.fromJson(data);
  }

  Future<List<SoilHealthModel>> getSoilHealthModelFor(String farmId) async {
    final (serviceAction, data) = await _dbManagerService.getList(id: _farmId(farmId), listId: _soilHealthModelsListId);

    if (serviceAction == ServiceAction.failure) {
      throw Exception('$tag: getSoilHealthModelFor($farmId) failed');
    }

    return data.map<SoilHealthModel>((d) => SoilHealthModel.fromJson(d)).toList();
  }

  Future<List<HarvestModel>> getHarvestModelsFor(String farmId) async {
    final (serviceAction, data) = await _dbManagerService.getList(id: _farmId(farmId), listId: _harvestModelsListId);

    if (serviceAction == ServiceAction.failure) {
      throw Exception('$tag: getHarvestModelFor($farmId) failed');
    }

    return data.map<HarvestModel>((d) => HarvestModel.fromJson(d)).toList();
  }

  Future<ServiceAction> addSoilHealthModelFor(
    String farmId, {
    required SoilHealthModel soilHealthModel,
  }) {
    return _dbManagerService.addToListAt(
      soilHealthModel.id,
      id: _farmId(farmId),
      listId: _soilHealthModelsListId,
      data: soilHealthModel.toJson(),
    );
  }

  Future<ServiceAction> addHarvestModelFor(
    String farmId, {
    required HarvestModel harvestModel,
  }) {
    return _dbManagerService.addToListAt(
      harvestModel.id,
      id: _farmId(farmId),
      listId: _harvestModelsListId,
      data: harvestModel.toJson(),
    );
  }

  Future<ServiceAction> updateHarestModelsFor(
    String farmId, {
    required List<HarvestStateUpdateModel> stateUpdates,
  }) async {
    final futures = <Future<ServiceAction>>[];

    for (final d in stateUpdates) {
      futures.add(
        _dbManagerService.updateListItemAt(d.id, id: _farmId(farmId), listId: _harvestModelsListId, data: d.toJson()),
      );
    }

    final response = await Future.wait(futures);
    if (response.any((e) => e == ServiceAction.failure)) {
      return ServiceAction.failure;
    }

    return ServiceAction.success;
  }

  Future<ServiceAction> updateSoilHealth({
    required String farmId,
    required SoilHealthValueUpdateModel data,
  }) async {
    final status = await _dbManagerService.update(id: _farmId(farmId), data: data.toJson());
    if (status == ServiceAction.failure) return status;

    /// updating soil health is an important action, we must immediately sync
    return _dbManagerService.sync();
  }

  /// TODO: Other db requirements!
  /// 1. Achievements
}
