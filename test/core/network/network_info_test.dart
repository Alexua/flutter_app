import 'package:flutter_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

void main(){
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('Is Connected', (){
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async
        {
          when(mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) async => true);

          final result  = await networkInfoImpl.isConnected;
          verify(mockDataConnectionChecker.hasConnection);
          expect(result, true);
        });
  });
}
