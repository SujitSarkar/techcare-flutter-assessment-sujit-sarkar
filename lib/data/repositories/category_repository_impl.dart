import 'package:take_home/data/datasources/category_remote_datasource.dart';
import 'package:take_home/domain/entities/category.dart';
import 'package:take_home/domain/repositories/category_repository.dart';
import 'package:take_home/core/constants/app_strings.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      return categoryModels.map((model) => model).toList();
    } catch (e) {
      throw Exception('${AppStrings.failedToFetchCategories}$e');
    }
  }
}
