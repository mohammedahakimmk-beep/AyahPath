import 'package:flutter_test/flutter_test.dart';
import 'package:ayahpath/services/update_service.dart';

void main() {
  group('UpdateService._isVersionBelow', () {
    test('equal versions are not below', () {
      expect(UpdateService.isVersionBelow('1.0.0', '1.0.0'), isFalse);
    });

    test('lower major version is below', () {
      expect(UpdateService.isVersionBelow('1.9.9', '2.0.0'), isTrue);
    });

    test('higher major version is not below', () {
      expect(UpdateService.isVersionBelow('2.0.0', '1.9.9'), isFalse);
    });

    test('lower minor version is below', () {
      expect(UpdateService.isVersionBelow('1.1.0', '1.2.0'), isTrue);
    });

    test('lower patch version is below', () {
      expect(UpdateService.isVersionBelow('1.2.3', '1.2.4'), isTrue);
    });

    test('single part versions compare', () {
      expect(UpdateService.isVersionBelow('1', '2'), isTrue);
    });

    test('short vs long versions', () {
      expect(UpdateService.isVersionBelow('1.2', '1.2.1'), isTrue);
    });
  });
}
