import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/validators.dart';

void main() {
  group('required', () {
    final rule = Validators.required('Name');

    test('rejects null, empty and whitespace-only input', () {
      expect(rule(null), 'Name is required.');
      expect(rule(''), 'Name is required.');
      expect(rule('   '), 'Name is required.');
    });

    test('accepts real text', () {
      expect(rule('Universitas Indonesia'), isNull);
    });
  });

  group('length', () {
    final rule = Validators.length('Title', min: 2, max: 5);

    test('ignores empty input so it can be combined with required', () {
      expect(rule(''), isNull);
    });

    test('enforces minimum and maximum on trimmed text', () {
      expect(rule('a'), contains('at least 2'));
      expect(rule('abcdef'), contains('at most 5'));
      expect(rule('  ab  '), isNull);
    });
  });

  group('url', () {
    test('accepts empty and valid http(s) URLs', () {
      expect(Validators.url(''), isNull);
      expect(Validators.url('https://example.com/demo'), isNull);
      expect(Validators.url('http://my.site'), isNull);
    });

    test('rejects other input', () {
      expect(Validators.url('example'), isNotNull);
      expect(Validators.url('ftp://example.com'), isNotNull);
      expect(Validators.url('https://'), isNotNull);
    });
  });

  group('gpa', () {
    test('accepts empty and values from 0 to 4', () {
      expect(Validators.gpa(''), isNull);
      expect(Validators.gpa('0'), isNull);
      expect(Validators.gpa('3.75'), isNull);
      expect(Validators.gpa('3,75'), isNull);
      expect(Validators.gpa('4.00'), isNull);
    });

    test('rejects non-numbers and out-of-range values', () {
      expect(Validators.gpa('abc'), isNotNull);
      expect(Validators.gpa('4.5'), isNotNull);
      expect(Validators.gpa('-1'), isNotNull);
    });
  });

  group('dates', () {
    final start = DateTime(2023, 8, 1);

    test('requiredDate rejects null', () {
      expect(Validators.requiredDate(null, 'start date'), isNotNull);
      expect(Validators.requiredDate(start, 'start date'), isNull);
    });

    test('dateOrder rejects an end before the start', () {
      expect(Validators.dateOrder(start, DateTime(2023, 7, 31)), isNotNull);
      expect(Validators.dateOrder(start, start), isNull);
      expect(Validators.dateOrder(start, DateTime(2027, 7, 1)), isNull);
      expect(Validators.dateOrder(start, null), isNull);
    });
  });

  test('combine returns the first error', () {
    final rule = Validators.combine([
      Validators.required('Field'),
      Validators.length('Field', min: 3, max: 10),
    ]);
    expect(rule(''), 'Field is required.');
    expect(rule('ab'), contains('at least 3'));
    expect(rule('abc'), isNull);
  });
}
