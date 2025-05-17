import 'package:shared_preferences/shared_preferences.dart';

class CacheController {

  /// SINGLETON
  CacheController._private();

  static CacheController cacheController = CacheController._private();

  factory CacheController() => cacheController;

  /// CACHE
  late SharedPreferences cache;

  Future<void> initCache() async {
    cache = await SharedPreferences.getInstance();
  }

  /// DATA

  Future<void> setter(String key, dynamic value) async {
    if (value is String) {
      await cache.setString(key, value);
    } else if (value is int) {
      await cache.setInt(key, value);
    } else if (value is double) {
      await cache.setDouble(key, value);
    } else if (value is bool) {
      await cache.setBool(key, value);
    } else if (value is List<String>) {
      await cache.setStringList(key, value);
    }
  }

  dynamic getter(String key) => cache.get(key);
  /// Save , Clear ,isLoggedIn ,getByKey<T> ,getToken

  Future<List<String>> saveLastResult() async => [];
  Future<bool> clearData() async {
    var x = await cache.clear() ;
    return x ;

  }
}
