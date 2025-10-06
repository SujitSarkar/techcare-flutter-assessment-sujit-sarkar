import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Result<Failure, List<Category>>> getCategories();
}
