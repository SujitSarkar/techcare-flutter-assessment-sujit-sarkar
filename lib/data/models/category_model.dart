import 'package:take_home/core/utils/utils.dart';
import 'package:take_home/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.color,
    required super.budget,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: Utils.stringToColor(json['color']),
      budget: (json['budget'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'color': Utils.colorToString(color), 'budget': budget};
  }

  Category toEntity() {
    return Category(id: id, name: name, icon: icon, color: color, budget: budget);
  }
}
