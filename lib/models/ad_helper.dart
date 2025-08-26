import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bool.fromEnvironment('dart.vm.product')
          ? 'ca-app-pub-7104002362240268/7933560793'
          : 'ca-app-pub-3940256099942544/6300978111';
    }
    throw UnsupportedError('Unsupported platform');
  }
}
