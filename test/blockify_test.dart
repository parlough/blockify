import 'package:blockify/blockify.dart' as blockify;
import 'package:test/test.dart';

const testContent = 'blockify';

void main() {
  group('Test error conditions', () {
    test('Throws if too small blockAmount', () {
      expect(
        () => blockify.render(content: testContent, blockAmount: -5),
        throwsRangeError,
      );
    });

    test('Does not throw with proper blockAmount', () {
      expect(
        () => blockify.render(content: testContent, blockAmount: 8),
        isNot(throwsRangeError),
      );
    });

    test('Throws if too large blockAmount', () {
      expect(
        () => blockify.render(content: testContent, blockAmount: 30),
        throwsRangeError,
      );
    });

    test('Throws if size is negative', () {
      expect(
        () => blockify.render(content: testContent, size: -4),
        throwsRangeError,
      );
    });

    test('Throws if size is 0', () {
      expect(
        () => blockify.render(content: testContent, size: 0),
        throwsRangeError,
      );
    });

    test('Throws if size is not even', () {
      expect(
        () => blockify.render(content: testContent, size: 301),
        throwsArgumentError,
      );
    });

    test('Does not throw if size is even', () {
      expect(
        () => blockify.render(content: testContent, size: 300),
        isNot(throwsArgumentError),
      );
    });
  });

  group('Test image properties', () {
    test('Default size correctly evaluates to 256', () {
      expect(
        blockify.render(content: testContent).height,
        equals(256),
      );
      expect(
        blockify.render(content: testContent).width,
        equals(256),
      );
    });

    test('Can correctly override size', () {
      expect(
        blockify.render(content: testContent, size: 512).height,
        equals(512),
      );
      expect(
        blockify.render(content: testContent, size: 512).width,
        equals(512),
      );
    });
  });
}
