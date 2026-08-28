import 'package:get_it/get_it.dart';
import 'features/customer/data/datasources/dashboard_remote_data_source.dart';
import 'features/customer/data/repositories/dashboard_repository_impl.dart';
import 'features/customer/presentation/bloc/dashboard_cubit.dart';
import 'features/admin/data/repositories/admin_dashboard_repository_impl.dart';
import 'features/admin/data/datasources/admin_remote_data_source.dart';
import 'features/admin/presentation/bloc/admin_dashboard_cubit.dart';
import 'features/dealer/data/datasources/dealer_remote_data_source.dart';
import 'features/dealer/data/repositories/dealer_repository_impl.dart';
import 'features/dealer/presentation/bloc/dealer_dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Customer Dashboard
  // Bloc
  sl.registerFactory(() => DashboardCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl());

  // Features - Admin Dashboard
  sl.registerFactory(() => AdminDashboardCubit(sl()));
  sl.registerLazySingleton<AdminDashboardRepository>(() => AdminDashboardRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl());

  // Features - Dealer Dashboard
  sl.registerFactory(() => DealerDashboardCubit(repository: sl()));
  sl.registerLazySingleton<DealerRepository>(() => DealerRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<DealerRemoteDataSource>(() => DealerRemoteDataSourceImpl());
}
