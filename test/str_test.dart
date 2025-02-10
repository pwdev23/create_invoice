import 'package:create_invoice/src/pages/preview_state.dart' show getTextLogo;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Get text logo should return correct string', () {
    test('Get text logo should return two uppercase letters', () {
      const name = 'Build Your Dreams';
      final str = getTextLogo(name);
      expect(str, 'BY');
    });

    test('Get text logo should return one uppercase letter', () {
      const name = 'Coca-Cola';
      final str = getTextLogo(name);
      expect(str, 'C');
    });
  });
}
