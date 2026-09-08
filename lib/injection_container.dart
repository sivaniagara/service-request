import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/http_service.dart';
import 'core/network/token_manager.dart';
import 'features/customer/data/datasources/dashboard_remote_data_source.dart';
import 'features/customer/data/repositories/dashboard_repository_impl.dart';
import 'features/customer/presentation/bloc/dashboard_cubit.dart';
import 'features/customer/presentation/bloc/complaint_cubit.dart';
import 'features/admin/data/repositories/admin_dashboard_repository_impl.dart';
import 'features/admin/data/datasources/admin_remote_data_source.dart';
import 'features/admin/presentation/bloc/admin_dashboard_cubit.dart';
import 'features/dealer/data/datasources/dealer_remote_data_source.dart';
import 'features/dealer/data/repositories/dealer_repository_impl.dart';
import 'features/dealer/presentation/bloc/dealer_dashboard_cubit.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/service_person/data/datasources/technician_remote_data_source.dart';
import 'features/service_person/data/repositories/technician_repository.dart';
import 'features/service_person/presentation/bloc/technician_dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => TokenManager(sharedPreferences: sl()));
  
  sl.registerLazySingleton<HttpService>(() => HttpService(
    client: sl(), 
    baseUrl: sl(instanceName: 'baseUrl'),
    tokenManager: sl(),
  ));
  sl.registerLazySingleton<String>(() => "http://192.168.1.45:8000", instanceName: 'baseUrl');

  // Features - Auth
  sl.registerFactory(() => AuthCubit(repository: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDataSource: sl(),
    tokenManager: sl(),
  ));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(httpService: sl<HttpService>()));

  // Features - Customer Dashboard
  // Bloc
  sl.registerFactory(() => DashboardCubit(repository: sl()));
  sl.registerFactory(() => ComplaintCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(httpService: sl()));

  // Features - Admin Dashboard
  sl.registerFactory(() => AdminDashboardCubit(sl()));
  sl.registerLazySingleton<AdminDashboardRepository>(() => AdminDashboardRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl(httpService: sl()));

  // Features - Dealer Dashboard
  sl.registerFactory(() => DealerDashboardCubit(repository: sl()));
  sl.registerLazySingleton<DealerRepository>(() => DealerRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<DealerRemoteDataSource>(() => DealerRemoteDataSourceImpl(httpService: sl()));

  // Features - Technician Dashboard
  sl.registerFactory(() => TechnicianDashboardCubit(repository: sl()));
  sl.registerLazySingleton<TechnicianRepository>(() => TechnicianRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<TechnicianRemoteDataSource>(() => TechnicianRemoteDataSourceImpl(httpService: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
