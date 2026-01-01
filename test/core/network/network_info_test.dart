import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_task_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;
  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test('should forward the call to Connectivity.checkConnectivity', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      // Act

      await networkInfoImpl.isConnected;

      // Verify
      verify(mockConnectivity.checkConnectivity());
    });
    test('should return true when connectivity is not none', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      // Act
      final result = await networkInfoImpl.isConnected;
      // Assert
      expect(result, true);
    });

    test('should return false when connectivity is none', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);
      // Act
      final result = await networkInfoImpl.isConnected;
      // Assert
      expect(result, false);
    });
  });
}
