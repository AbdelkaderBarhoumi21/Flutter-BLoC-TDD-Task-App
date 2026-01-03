import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_app/core/error/firebase_exceptions.dart';

abstract class FirebaseRemoteConfigService {
  /// Fetch remote config from server
  Future<void> fetch();

  /// Activate fetched config
  Future<bool> activate();

  /// Fetch and activate in one call
  Future<bool> fetchAndActivate();

  /// Get boolean value
  bool getBool(String key);

  /// Get integer value
  int getInt(String key);

  /// Get double value
  double getDouble(String key);

  /// Get string value
  String getString(String key);

  /// Get all config
  Map<String, dynamic> getAll();

  /// Set default values
  Future<void> setDefaults(Map<String, dynamic> defaults);

  /// Set config settings
  Future<void> setConfigSettings(RemoteConfigSettings settings);
}

/// Implementation of Firebase Remote Config Service
class FirebaseRemoteConfigServiceImpl implements FirebaseRemoteConfigService {
  const FirebaseRemoteConfigServiceImpl(this._remoteConfig);
  final FirebaseRemoteConfig _remoteConfig;
  @override
  Future<void> fetch() async {
    try {
      await _remoteConfig.fetch();
      if (kDebugMode) {
        debugPrint('Remote Config fetched');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config fetch failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to fetch remote config',
        e.toString(),
      );
    }
  }

  @override
  Future<bool> activate() {
    try {
      final activated = _remoteConfig.activate();
      if (kDebugMode) {
        print('🔧 Remote Config activated: $activated');
      }

      return activated;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config activate failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to activate remote config',
        e.toString(),
      );
    }
  }

  @override
  Future<bool> fetchAndActivate() {
    try {
      final activated = _remoteConfig.fetchAndActivate();
      if (kDebugMode) {
        debugPrint('Remote Config fetch and activated: $activated');
      }
      return activated;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config fetchAndActivate failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to fetch and activate remote config',
        e.toString(),
      );
    }
  }

  @override
  bool getBool(String key) {
    try {
      final value = _remoteConfig.getBool(key);
      if (kDebugMode) {
        debugPrint('Remote Config Get: $key = $value');
      }
      return value;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config getBool failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to get boolean value for key: $key',
        e.toString(),
      );
    }
  }

  @override
  int getInt(String key) {
    try {
      final value = _remoteConfig.getInt(key);

      if (kDebugMode) {
        debugPrint('Remote Config Get: $key = $value');
      }

      return value;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config getInt failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to get integer value for key: $key',
        e.toString(),
      );
    }
  }

  @override
  double getDouble(String key) {
    try {
      final value = _remoteConfig.getDouble(key);

      if (kDebugMode) {
        debugPrint('Remote Config Get: $key = $value');
      }

      return value;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config getDouble failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to get double value for key: $key',
        e.toString(),
      );
    }
  }

  @override
  String getString(String key) {
    try {
      final value = _remoteConfig.getString(key);

      if (kDebugMode) {
        debugPrint('Remote Config Get: $key = $value');
      }

      return value;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config getString failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to get string value for key: $key',
        e.toString(),
      );
    }
  }

  @override
  Map<String, dynamic> getAll() {
    try {
      //RemoteConfigValue => String asString() , int asInt() ...
      final allValues = _remoteConfig
          .getAll(); // return Map<String, RemoteConfigValue>
      final result = <String, dynamic>{};

      for (final entry in allValues.entries) {
        result[entry.key] = entry.value.asString();
      }

      if (kDebugMode) {
        debugPrint('Remote Config Get All: ${result.length} values');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config getAll failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to get all config values',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    try {
      await _remoteConfig.setDefaults(defaults);

      if (kDebugMode) {
        debugPrint('Remote Config defaults set: ${defaults.length} values');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config setDefaults failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to set defaults',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {
    try {
      await _remoteConfig.setConfigSettings(settings);

      if (kDebugMode) {
        debugPrint('Remote Config settings updated');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config setConfigSettings failed: $e');
      }
      throw FirebaseRemoteConfigException(
        'Failed to set config settings',
        e.toString(),
      );
    }
  }
}
