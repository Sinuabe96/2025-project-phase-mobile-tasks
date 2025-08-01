import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lidiya/core/network/network_info.dart';
import 'package:lidiya/core/network/network_info_impl.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to InternetConnectionChecker.hasConnection', () async {
      // arrange
      final tHasConnectionFuture = Future.value(true);
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);

      // act
      final result = networkInfo.isConnected;

      // assert
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });

    test('should return true when internet connection is available', () async {
      // arrange
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
      verify(mockInternetConnectionChecker.hasConnection).called(1);
    });

    test('should return false when internet connection is not available', () async {
      // arrange
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, false);
      verify(mockInternetConnectionChecker.hasConnection).called(1);
    });

    test('should return false when InternetConnectionChecker throws an exception', () async {
      // arrange
      when(mockInternetConnectionChecker.hasConnection)
          .thenThrow(Exception('Connection check failed'));

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, false);
      verify(mockInternetConnectionChecker.hasConnection).called(1);
    });
  });
} 