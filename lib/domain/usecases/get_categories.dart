import 'package:finance_tracker/core/errors/failure.dart';
import 'package:finance_tracker/core/errors/result.dart';
import 'package:finance_tracker/domain/entities/category.dart';
import 'package:finance_tracker/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<Result<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}
