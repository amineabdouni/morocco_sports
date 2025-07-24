import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// خدمة التخزين المحلي (Storage Service)
/// توفر واجهة موحدة للتعامل مع SharedPreferences
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._internal();

  factory StorageService() {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  /// تهيئة الخدمة
  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// الحصول على SharedPreferences
  Future<SharedPreferences> get _prefs async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // ===== String Operations =====
  
  /// حفظ نص
  Future<bool> setString(String key, String value) async {
    final prefs = await _prefs;
    return await prefs.setString(key, value);
  }

  /// قراءة نص
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  // ===== Int Operations =====
  
  /// حفظ رقم صحيح
  Future<bool> setInt(String key, int value) async {
    final prefs = await _prefs;
    return await prefs.setInt(key, value);
  }

  /// قراءة رقم صحيح
  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  // ===== Double Operations =====
  
  /// حفظ رقم عشري
  Future<bool> setDouble(String key, double value) async {
    final prefs = await _prefs;
    return await prefs.setDouble(key, value);
  }

  /// قراءة رقم عشري
  Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  // ===== Bool Operations =====
  
  /// حفظ قيمة منطقية
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(key, value);
  }

  /// قراءة قيمة منطقية
  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  // ===== StringList Operations =====
  
  /// حفظ قائمة نصوص
  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    return await prefs.setStringList(key, value);
  }

  /// قراءة قائمة نصوص
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  // ===== JSON Operations =====
  
  /// حفظ كائن JSON
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    return await setString(key, jsonString);
  }

  /// قراءة كائن JSON
  Future<Map<String, dynamic>?> getJson(String key) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;
    
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// حفظ قائمة JSON
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) async {
    final jsonString = json.encode(value);
    return await setString(key, jsonString);
  }

  /// قراءة قائمة JSON
  Future<List<Map<String, dynamic>>?> getJsonList(String key) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;
    
    try {
      final decoded = json.decode(jsonString) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  // ===== Utility Operations =====
  
  /// التحقق من وجود مفتاح
  Future<bool> containsKey(String key) async {
    final prefs = await _prefs;
    return prefs.containsKey(key);
  }

  /// حذف مفتاح
  Future<bool> remove(String key) async {
    final prefs = await _prefs;
    return await prefs.remove(key);
  }

  /// مسح جميع البيانات
  Future<bool> clear() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }

  /// الحصول على جميع المفاتيح
  Future<Set<String>> getAllKeys() async {
    final prefs = await _prefs;
    return prefs.getKeys();
  }

  /// إعادة تحميل البيانات
  Future<void> reload() async {
    final prefs = await _prefs;
    await prefs.reload();
  }

  // ===== Advanced Operations =====
  
  /// حفظ مع انتهاء صلاحية
  Future<bool> setWithExpiry(String key, String value, Duration expiry) async {
    final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
    final data = {
      'value': value,
      'expiry': expiryTime,
    };
    return await setJson('${key}_expiry', data);
  }

  /// قراءة مع التحقق من انتهاء الصلاحية
  Future<String?> getWithExpiry(String key) async {
    final data = await getJson('${key}_expiry');
    if (data == null) return null;
    
    final expiryTime = data['expiry'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    if (now > expiryTime) {
      await remove('${key}_expiry');
      return null;
    }
    
    return data['value'] as String;
  }

  /// حفظ مع تشفير بسيط (Base64)
  Future<bool> setEncrypted(String key, String value) async {
    final encoded = base64.encode(utf8.encode(value));
    return await setString('${key}_enc', encoded);
  }

  /// قراءة مع فك التشفير
  Future<String?> getDecrypted(String key) async {
    final encoded = await getString('${key}_enc');
    if (encoded == null) return null;
    
    try {
      final decoded = utf8.decode(base64.decode(encoded));
      return decoded;
    } catch (e) {
      return null;
    }
  }

  /// إحصائيات التخزين
  Future<Map<String, dynamic>> getStorageStats() async {
    final keys = await getAllKeys();
    final prefs = await _prefs;
    
    int totalKeys = keys.length;
    int stringKeys = 0;
    int intKeys = 0;
    int boolKeys = 0;
    int listKeys = 0;
    
    for (String key in keys) {
      final value = prefs.get(key);
      if (value is String) stringKeys++;
      else if (value is int) intKeys++;
      else if (value is bool) boolKeys++;
      else if (value is List) listKeys++;
    }
    
    return {
      'totalKeys': totalKeys,
      'stringKeys': stringKeys,
      'intKeys': intKeys,
      'boolKeys': boolKeys,
      'listKeys': listKeys,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  /// نسخ احتياطي من البيانات
  Future<Map<String, dynamic>> backup() async {
    final keys = await getAllKeys();
    final prefs = await _prefs;
    final backup = <String, dynamic>{};
    
    for (String key in keys) {
      backup[key] = prefs.get(key);
    }
    
    return {
      'data': backup,
      'timestamp': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }

  /// استعادة من النسخة الاحتياطية
  Future<bool> restore(Map<String, dynamic> backupData) async {
    try {
      final data = backupData['data'] as Map<String, dynamic>;
      final prefs = await _prefs;
      
      // مسح البيانات الحالية
      await clear();
      
      // استعادة البيانات
      for (String key in data.keys) {
        final value = data[key];
        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
