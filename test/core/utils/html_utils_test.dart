import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/core/utils/html_utils.dart';

void main() {
  group('htmlDecode', () {
    test('decodes &amp; to &', () {
      expect(htmlDecode('BBC &amp; ITV'), 'BBC & ITV');
    });

    test('decodes &lt; and &gt;', () {
      expect(htmlDecode('a &lt; b &gt; c'), 'a < b > c');
    });

    test('decodes &quot;', () {
      expect(htmlDecode('He said &quot;hello&quot;'), 'He said "hello"');
    });

    test('decodes &#39; to single quote', () {
      expect(htmlDecode('it&#39;s'), "it's");
    });

    test('passes through plain text unchanged', () {
      expect(htmlDecode('Hello World'), 'Hello World');
    });

    test('handles empty string', () {
      expect(htmlDecode(''), '');
    });

    test('handles string with no entities', () {
      expect(htmlDecode('No entities here 123'), 'No entities here 123');
    });

    test('decodes multiple entities', () {
      expect(htmlDecode('A &amp; B &lt; C &gt; D'), 'A & B < C > D');
    });

    test('handles numeric entities', () {
      expect(htmlDecode('&#65;'), 'A');
      expect(htmlDecode('&#x41;'), 'A');
    });
  });
}
