import 'package:shared_preferences/shared_preferences.dart';

class CreditManager {
  static const String _creditKey = 'flip_credits';
  static const String _isFirstTimeKey = 'is_first_time_user';
  static const int _initialCredits = 100;

  static Future<int> getCredits() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if it's first time user
    final isFirstTime = prefs.getBool(_isFirstTimeKey) ?? true;
    
    if (isFirstTime) {
      // Set initial credits for first time user
      await prefs.setInt(_creditKey, _initialCredits);
      // Mark that user has received initial credits
      await prefs.setBool(_isFirstTimeKey, false);
      return _initialCredits;
    }
    
    return prefs.getInt(_creditKey) ?? 0;
  }

  static Future<void> addCredits(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCredits = await getCredits();
    await prefs.setInt(_creditKey, currentCredits + amount);
  }

  static Future<bool> useCredits(int amount) async {
    final currentCredits = await getCredits();
    if (currentCredits >= amount) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_creditKey, currentCredits - amount);
      return true;
    }
    return false;
  }
}