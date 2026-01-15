import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/set_user_id_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/set_user_properties_usecase.dart';

class UserService {
  Future<void> setUserContext(String userId, String userType) async {
    final setUserProperties = firebase_di.sl<SetUserPropertiesUseCase>();
    final setUserId = firebase_di.sl<SetUserIdUseCase>();
    await setUserProperties(
      SetUserPropertiesParams(name: 'user_type', value: userType),
    );

    await setUserProperties(
      const SetUserPropertiesParams(name: 'app_version', value: '1.0.0'),
    );

    await setUserId(SetUserIdParams(userId: userId));
  }
}
