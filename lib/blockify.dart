/// Generate and render an image based off any [String] you specify
/// with the configurable [render] function
/// to use as profile pictures, identifiers, or more.
library blockify;

import 'dart:convert';

import 'package:crypto/crypto.dart' show sha512;
import 'package:image/image.dart';

/// Render a [Image] that is automatically generated based off the SHA-256
/// of the [content] you specified. As a result, barring any changes in the
/// algorithm between releases, if you specify the same parameters, the
/// resulting image will be the same.
///
/// It will be rendered at a size of [size]*[size] which must be a positive
/// and even integer. This defaults to a `256x256` image.
///
/// It will have the specified [backgroundColor] which should be a 32-bit ARGB
/// integer. By default, this is white or `0xFFFFFFFF`.
///
/// There will be a square of blocks that is [blockAmount]x[blockAmount]
/// large where each "block" is of equivalent size. This often looks better as
/// an odd number and defaults to `5` and must be no greater than 8.
///
/// These "blocks" will be a single color either the [primaryColor] you specify
/// or a color generated from the last few bytes of the generated hash.
///
/// You can control the margin outside of the block of "blocks" by specifying
/// a decimal [margin] which if not in the range of 0-1 will be clamped to fit.
Image render(
    {required final String content,
    final int backgroundColor = 0xFFFFFFFF,
    int? primaryColor,
    final int size = 256,
    final double margin = .12,
    final int blockAmount = 5}) {
  if (blockAmount < 1 || blockAmount > 8) {
    throw RangeError.value(
        blockAmount, 'blockAmount', 'blockAmount must be between 1 and 8.');
  }

  if (size <= 1) {
    throw RangeError.value(size, 'size', 'size must be greater than 0.');
  }

  if (size.isOdd) {
    throw ArgumentError.value(
        size, 'size', 'The size of the image must be even.');
  }

  final data = sha512.convert(utf8.encode(content)).bytes;

  if (primaryColor == null) {
    final amount = data.length;
    var lastTwoWords = 0;
    for (var i = 0; i < 4; i++) {
      lastTwoWords += data[amount - i - 1] << (i * 8);
    }
    primaryColor = lastTwoWords;
  }

  final image = Image(size, size);

  fillRect(image, 0, 0, size - 1, size - 1, backgroundColor);

  margin.clamp(0, 1);

  final marginSize = (size * margin).toInt();
  final blockSize = (size - (marginSize * 2)) ~/ blockAmount;

  void drawCellRect(int x, int y, final int color) {
    x = x * blockSize + marginSize;
    y = y * blockSize + marginSize;
    fillRect(image, x, y, x + blockSize - 1, y + blockSize - 1, color);
  }

  final evenMiddle = blockAmount.isEven;
  final columns = (blockAmount / 2).ceil();

  for (var x = 0; x < columns; x++) {
    for (var y = 0; y < blockAmount; y++) {
      // Choose to include the block if its byte is odd
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
