import 'package:flutter/material.dart';

class Utils {
  Utils._();

  static Color stringToColor(String colorString) {
    try {
      // Remove # if present
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

  static String colorToString(Color color) {
    // Convert to ARGB32 and then to hex string, removing the alpha channel
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).substring(2).toUpperCase()}';
  }
}
