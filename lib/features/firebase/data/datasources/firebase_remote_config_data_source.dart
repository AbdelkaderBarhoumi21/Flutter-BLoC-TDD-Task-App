import 'package:flutter_task_app/core/firebase/services/firebase_remote_config_service.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/app_config_entity.dart';

/// Contract for Remote Config data source
abstract class FirebaseRemoteConfigDataSource {
  Future<bool> fetchAndActivate();
  dynamic getValue(String key);
  AppConfigEntity getAllValues();
  bool getBool(String key);
  int getInt(String key);
  String getString(String key);
}

/// Implementation of Remote Config data source
class FirebaseRemoteConfigDataSourceImpl
    implements FirebaseRemoteConfigDataSource {

  FirebaseRemoteConfigDataSourceImpl({required this.remoteConfigService});
  final FirebaseRemoteConfigService remoteConfigService;

  @override
  Future<bool> fetchAndActivate() async => await remoteConfigService.fetchAndActivate();

  @override
  dynamic getValue(String key) {
    final rawValue = remoteConfigService.getString(key);
    return _parseConfigValue(rawValue);
  }

  dynamic _parseConfigValue(String rawValue) {
    final trimmed = rawValue.trim();
    final normalized = trimmed.toLowerCase();
    if (normalized == 'true') {
      return true;
    }
    if (normalized == 'false') {
      return false;
    }
    final intValue = int.tryParse(trimmed);
    if (intValue != null) {
      return intValue;
    }
    final doubleValue = double.tryParse(trimmed);
    if (doubleValue != null) {
      return doubleValue;
    }
    return rawValue;
  }

  @override
  AppConfigEntity getAllValues() {
    final values = remoteConfigService.getAll();
    return AppConfigEntity(values);
  }

  @override
  bool getBool(String key) => remoteConfigService.getBool(key);

  @override
  int getInt(String key) => remoteConfigService.getInt(key);

  @override
  String getString(String key) => remoteConfigService.getString(key);
}
