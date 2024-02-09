import 'package:babyfood/core/platform/network_info.dart';
import 'package:babyfood/feature/data/datasources/guide_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/guide_remote_datasource.dart';
import 'package:babyfood/feature/data/datasources/food_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/food_remote_datasource.dart';
import 'package:babyfood/feature/data/datasources/recipe_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/recipe_remote_datasource.dart';
import 'package:babyfood/feature/data/repositories/guide_repository_impl.dart';
import 'package:babyfood/feature/data/repositories/recipe_repository_impl.dart';
import 'package:babyfood/feature/domain/repositories/guide_repository.dart';
import 'package:babyfood/feature/domain/repositories/person_repository.dart';
import 'package:babyfood/feature/domain/repositories/recipe_repository.dart';
import 'package:babyfood/feature/domain/usecases/get_all_guides.dart';
import 'package:babyfood/feature/domain/usecases/get_all_recipes.dart';
import 'package:babyfood/feature/domain/usecases/search_recipe.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature/data/repositories/food_repository_impl.dart';
import 'feature/domain/usecases/get_all_foods.dart';
import 'feature/domain/usecases/search_food.dart';
import 'feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'feature/presentation/bloc/search_bloc/search_bloc.dart';

import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit
  sl.registerFactory(
        () => GuideListCubit(getAllGuides: sl<GetAllGuides>()),
  );
  sl.registerFactory(
        () => ConvenienceFoodListCubit(getAllFoods: sl<GetAllFoods>()),
  );
  sl.registerFactory(
        () => PersonSearchBloc(searchPerson: sl()),
  );
  sl.registerFactory(
        () => RecipeListCubit(getAllRecipes: sl<GetAllRecipes>()),
  );
  sl.registerFactory(
        () => RecipeSearchBloc(searchRecipe: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetAllGuides(sl()));
  sl.registerLazySingleton(() => GetAllFoods(sl()));
  sl.registerLazySingleton(() => SearchFood(sl()));
  sl.registerLazySingleton(() => GetAllRecipes(sl()));
  sl.registerLazySingleton(() => SearchRecipe(sl()));
  // Repository
  sl.registerLazySingleton<ConvenienceFoodRepository>(
        () => ConvenienceFoodRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ConvenienceFoodRemoteDataSource>(
        () => ConvenienceFoodRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<PersonLocalDataSource>(
        () => PersonLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<RecipeRepository>(
        () => RecipeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<RecipeRemoteDataSource>(
        () => RecipeRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<RecipeLocalDataSource>(
        () => RecipeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<GuideRepository>(
        () => GuideRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<GuideRemoteDataSource>(
        () => GuideRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<GuideLocalDataSource>(
        () => GuideLocalDataSourceImpl(sharedPreferences: sl()),
  );
  // Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImp(sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}