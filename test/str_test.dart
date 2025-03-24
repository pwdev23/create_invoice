import 'package:create_invoice/src/pages/preview_state.dart' show getTextLogo;
import 'package:create_invoice/src/utils.dart' show getVersionText;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Get text logo should return correct string', () {
    test('getTextLogo should return two uppercase letters', () {
      const name = 'Build Your Dreams';
      final str = getTextLogo(name);
      expect(str, 'BY');
    });

    test('getTextLogo should return one uppercase letter', () {
      const name = 'Coca-Cola';
      final str = getTextLogo(name);
      expect(str, 'C');
    });

    test('getVersionText should return correct version text', () {
      const kVersion = '0.0.2+2';
      final str = getVersionText(kVersion, 'Version', 'Build');
      expect(str, 'Version 0.0.2 Build(2)');
    });
  });
}
