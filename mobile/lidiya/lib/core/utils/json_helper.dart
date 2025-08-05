import 'dart:convert';

/// Utility class for JSON operations to reduce code duplication
class JsonHelper {
  /// Safely decode JSON string to Map
  static Map<String, dynamic>? safeDecode(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Safely decode JSON string to List
  static List<dynamic>? safeDecodeList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    
    try {
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Safely encode object to JSON string
  static String? safeEncode(dynamic object) {
    try {
      return jsonEncode(object);
    } catch (e) {
      return null;
    }
  }

  /// Convert list of objects to JSON strings
  static List<String> encodeList(List<dynamic> objects) {
    return objects
        .map((obj) => safeEncode(obj))
        .where((json) => json != null)
        .cast<String>()
        .toList();
  }

  /// Convert list of JSON strings to objects
  static List<Map<String, dynamic>> decodeList(List<String> jsonStrings) {
    return jsonStrings
        .map((json) => safeDecode(json))
        .where((obj) => obj != null)
        .cast<Map<String, dynamic>>()
        .toList();
  }
} 