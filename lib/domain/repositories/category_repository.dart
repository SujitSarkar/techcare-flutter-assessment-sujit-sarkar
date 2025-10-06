import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/core/errors/result.dart';
import 'package:take_home/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Result<Failure, List<Category>>> getCategories();
}
