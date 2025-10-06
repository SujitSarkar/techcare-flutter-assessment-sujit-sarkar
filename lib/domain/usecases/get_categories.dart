import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/core/errors/result.dart';
import 'package:take_home/domain/entities/category.dart';
import 'package:take_home/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<Result<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}
