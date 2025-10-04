import 'package:take_home/data/datasources/category_remote_datasource.dart';
import 'package:take_home/domain/entities/category.dart';
import 'package:take_home/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      return categoryModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
