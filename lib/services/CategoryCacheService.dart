import 'package:shared_preferences/shared_preferences.dart';

class CategoryCacheService {
  static const _key = 'selected_category_id';

  Future<void> saveSelectedCategoryId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, id);
  }

  Future<int?> getSelectedCategoryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key);
  }
}
