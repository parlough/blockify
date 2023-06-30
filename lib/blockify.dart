/// Generate and render an image based off any [String] you specify
/// with the configurable [render] function
/// to use as profile pictures, identifiers, or more.
library;

import 'dart:convert' show utf8;
import 'dart:math' show max;

import 'package:crypto/crypto.dart' show sha512;
import 'package:image/image.dart';

/// Render an [Image] that is automatically generated
/// based off the SHA-512 of the [content] you specify.
/// As a result, barring any changes in the algorithm between releases,
/// if you specify the same parameters,
/// the resulting image will be the same.
///
/// It will be rendered at a size of [size]*[size]
/// which must be a positive and even integer.
/// This defaults to a `256x256` image.
///
/// It will have the specified [backgroundColor],
/// which defaults to white.
///
/// There will be a square of blocks that is [blockAmount]x[blockAmount]
/// large where each "block" is of equivalent size.
/// This often looks better as an odd number and
/// defaults to `5` and must be no greater than 8.
///
/// These "blocks" will be a single color:
/// either the [primaryColor] you specify
/// or a color generated from the last few bytes of the generated hash.
///
/// You can control the margin outside of the block of "blocks"
/// by specifying a decimal [margin]
/// which if not in the range of 0-1 will be clamped to fit.
Image render({
  required final String content,
  Color? backgroundColor,
  Color? primaryColor,
  final int size = 256,
  final double margin = .12,
  final int blockAmount = 5,
}) {
  if (blockAmount < 1 || blockAmount > 8) {
    throw RangeError.value(
      blockAmount,
      'blockAmount',
      'blockAmount must be between 1 and 8.',
    );
  }

  if (size <= 1) {
    throw RangeError.value(
      size,
      'size',
      'size must be greater than 0.',
    );
  }

  if (size.isOdd) {
    throw ArgumentError.value(
      size,
      'size',
      'The size of the image must be even.',
    );
  }

  // Set the default background color to white.
  backgroundColor ??= ColorUint8.rgba(0xFF, 0xFF, 0xFF, 0xFF);

  final data = sha512.convert(utf8.encode(content)).bytes;

  if (primaryColor == null) {
    final amount = data.length;

    // Take the last 4 bytes as the default primary color.
    primaryColor = ColorUint8.rgba(
      data[amount - 3 - 1],
      data[amount - 2 - 1],
      data[amount - 1 - 1],
      data[amount - 0 - 1],
    );
  }

  final maxChannels = max(primaryColor.length, backgroundColor.length);

  final image = Image(
    width: size,
    height: size,
    numChannels: maxChannels,
    backgroundColor: backgroundColor,
  );

  image.clear(backgroundColor);

  final marginSize = (size * margin.clamp(0, 1)).truncate();
  final blockSize = (size - (marginSize * 2)) ~/ blockAmount;

  void drawCellRect(int x1, int y1, final Color color) {
    x1 = x1 * blockSize + marginSize;
    y1 = y1 * blockSize + marginSize;
    final x2 = x1 + blockSize - 1;
    final y2 = y1 + blockSize - 1;
    for (var x = x1; x <= x2; x++) {
      for (var y = y1; y <= y2; y++) {
        image.setPixel(x, y, color);
      }
    }
  }

  final evenMiddle = blockAmount.isEven;
  final columns = (blockAmount / 2).ceil();

  for (var x = 0; x < columns; x++) {
    for (var y = 0; y < blockAmount; y++) {
      // Choose to include the block if its byte is odd.
      if (data[x * blockAmount + y].isEven) continue;

      drawCellRect(x, y, primaryColor);
      if (x == columns - 1) {
        if (evenMiddle) {
          drawCellRect(x + 1, y, primaryColor);
        }
      } else {
        drawCellRect(blockAmount - x - 1, y, primaryColor);
      }
    }
  }

  return image;
}
