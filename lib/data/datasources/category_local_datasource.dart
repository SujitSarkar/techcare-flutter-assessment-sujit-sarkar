import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  static const String _cacheKey = 'cached_categories';
  static const String _cacheTimestampKey = 'categories_cache_timestamp';
  static const int _cacheValidityMinutes = 5;

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);

      if (cachedData == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(cachedData);
      return jsonList.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;

      // Convert categories to JSON
      final jsonList = categories.map((category) => category.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      // Cache the data and timestamp
      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(_cacheTimestampKey, now);
    } catch (e) {
      // Handle caching error silently
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestampKey);

      if (timestamp == null) {
        return false;
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime).inMinutes;

      return difference < _cacheValidityMinutes;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimestampKey);
    } catch (e) {
      // Handle cache clearing error silently
    }
  }
}
