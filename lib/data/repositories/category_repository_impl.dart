import 'package:take_home/data/datasources/category_remote_datasource.dart';
import 'package:take_home/data/datasources/category_local_datasource.dart';
import 'package:take_home/domain/entities/category.dart';
import 'package:take_home/domain/repositories/category_repository.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/utils/network_connection.dart';
import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/core/errors/result.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkConnection networkConnection;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkConnection,
  });

  @override
  Future<Result<Failure, List<Category>>> getCategories() async {
    final isOnline = await networkConnection.checkConnection();
    try {
      // Check if cache is valid
      final isCacheValid = await localDataSource.isCacheValid();
      if (isCacheValid) {
        final cachedCategories = await localDataSource.getCachedCategories();
        if (cachedCategories.isNotEmpty) {
          // Return cached data
          return Success(cachedCategories.map((model) => model).toList());
        }
      }

      // If offline, try to return cached data even if expired
      if (!isOnline) {
        final cachedCategories = await localDataSource.getCachedCategories();
        if (cachedCategories.isNotEmpty) {
          return Success(cachedCategories.map((model) => model).toList());
        }
        return const FailureResult(NetworkFailure('No internet connection and no cached data available'));
      }

      // Fetch from remote if online
      final categoryModels = await remoteDataSource.getCategories();

      // Cache the data
      await localDataSource.cacheCategories(categoryModels);

      return Success(categoryModels.map((model) => model).toList());
    } catch (e) {
      return FailureResult(UnknownFailure('${AppStrings.failedToFetchCategories}', cause: e));
    }
  }
}
