import 'package:take_home/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}
