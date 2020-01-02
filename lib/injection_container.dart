import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_app/core/network/network_info.dart';
import 'package:flutter_app/core/util/input_converter.dart';
import 'package:flutter_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_app/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_app/features/number_trivia/presentation/block/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  sl.registerFactory(
      () => NumberTriviaBloc(getConcreteNumberTrivia: sl(), getRandomNumberTrivia: sl(), inputConverter: sl()));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  //-- DataSources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(()=> InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(()=>sharedPreferences);
  sl.registerLazySingleton(()=>http.Client());
  sl.registerLazySingleton(()=>DataConnectionChecker());
  //sl.registerFactory(func)
}
