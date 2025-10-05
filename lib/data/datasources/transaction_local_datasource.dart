import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getCachedTransactions();
  Future<void> cacheTransactions(List<TransactionModel> transactions);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String _cacheKey = 'cached_transactions';
  static const String _cacheTimestampKey = 'transactions_cache_timestamp';
  static const int _cacheValidityMinutes = 5;

  @override
  Future<List<TransactionModel>> getCachedTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);

      if (cachedData == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(cachedData);
      return jsonList.map((json) => TransactionModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;

      // Convert transactions to JSON
      final jsonList = transactions.map((transaction) => transaction.toJson()).toList();
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
