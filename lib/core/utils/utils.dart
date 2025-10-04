import 'package:flutter/material.dart';

class Utils {
  Utils._();

  static Color stringToColor(String colorString) {
    try {
      String cleanColor = colorString.replaceFirst('#', '');
      // Add alpha if not present (assume full opacity)
      if (cleanColor.length == 6) {
        cleanColor = 'FF$cleanColor';
      }
      return Color(int.parse(cleanColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  static String colorToString(Color? color) {
    // Convert to ARGB32 and then to hex string, removing the alpha channel
    final argb = color?.toARGB32();
    return '#${argb?.toRadixString(16).substring(2).toUpperCase()}';
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'movie':
        return Icons.movie;
      case 'receipt':
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }
}
