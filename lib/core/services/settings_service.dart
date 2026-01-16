import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/core/utils/constants/app_config_keys.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/remote_config/fetch_remote_config_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/remote_config/get_config_value_usecase.dart';

class SettingsService {
  Future<void> initialize() async {
    // Fetch latest config
    final fetchConfig = firebase_di.sl<FetchRemoteConfigUseCase>();
    await fetchConfig(const FetchRemoteConfigParams());
  }

  Future<bool> get notificationsEnabled async {
    final getConfigValue = firebase_di.sl<GetConfigValueUseCase>();
    final result = await getConfigValue(
      const GetConfigValueParams(key: AppConfigKeys.enableNotifications),
    );

    return result.fold(
      (failure) => true, // Default value
      (value) => value as bool,
    );
  }

  Future<int> get maxTasksPerUser async {
    final getConfigValue = firebase_di.sl<GetConfigValueUseCase>();
    final result = await getConfigValue(
      const GetConfigValueParams(key: AppConfigKeys.maxTasksPerUser),
    );

    return result.fold(
      (failure) => 100, // Default value
      (value) => value as int,
    );
  }

  Future<String> get apiBaseUrl async {
    final getConfigValue = firebase_di.sl<GetConfigValueUseCase>();
    final result = await getConfigValue(
      const GetConfigValueParams(key: AppConfigKeys.apiBaseUrl),
    );

    return result.fold(
      (failure) => 'https://api.example.com', // Default value
      (value) => value as String,
    );
  }
}
