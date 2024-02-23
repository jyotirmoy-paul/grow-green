import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';

import '../../models/auth/user.dart';
import '../log/log.dart';
import '../utils/service_action.dart';
import 'interface/cloud_db_service.dart';
import 'interface/db_batch_write.dart';
import 'interface/db_manager_service.dart';

part 'impl/interval_sync_db_manager_service.dart';
part 'impl/firebase_cloud_db_service.dart';
part 'impl/firebase_db_batch_write.dart';

enum SupportedCloudDatabaseService {
  firebase,
}

enum SupportedDbManagerService {
  intervalSync,
}

abstract class CloudDatabaseServiceFactory {
  static CloudDbService build(SupportedCloudDatabaseService supportedCloudDatabaseService) {
    switch (supportedCloudDatabaseService) {
      case SupportedCloudDatabaseService.firebase:
        return _FirebaseCloudDbService();
    }
  }
}

abstract class DbManagerServiceFactory {
  static DbManagerService build(SupportedDbManagerService supportedDbManagerService) {
    switch (supportedDbManagerService) {
      case SupportedDbManagerService.intervalSync:
        return _IntervalSyncDbManagerService();
    }
  }
}