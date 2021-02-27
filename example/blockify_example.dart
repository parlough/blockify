import 'dart:io';

import 'package:blockify/blockify.dart';
import 'package:image/image.dart';

/// This example generates a rendered icon using most of the default parameter
/// values but setting the background as transparent. Then it proceeds to
/// encode the result as a PNG with the `image` package, and proceeds to store
/// the encoded PNG in a file named `parlough.png`.
///
/// You can find this and some other examples in the repository's
/// `example` directory.
void main() {
  const content = 'parlough';

  // Render the image with a transparent background
  final image = render(content: content, backgroundColor: 0);

  // Encode the image as a PNG image with the `image` package
  final encoded = encodePng(image);

  // Create a new file with the `dart:io` library
  final file = File('$content.png');

  // Finally write out the encoded PNG to the newly created file
  file.writeAsBytesSync(encoded);
}
