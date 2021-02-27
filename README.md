Generate and configure avatars based off of the hash of any arbitrary string content.

This functionality is inspired by Github's [identicons](https://github.blog/2013-08-14-identicons/) but uses
a different algorithm so will not result in identical outputs.

**NOTE:** The algorithm of this package may change over time to improve generated image quality, so there is no
guarantee of stability of generated images between versions. We will consider this a semver break, so if image
generation changes without any action by the user, we would for example upgrade the version from `0.1.0` -> `0.2.0` or
`1.0.0` -> `2.0.0`. We are always open to suggestions about how to improve the algorithm and/or image quality so please
reach out if you have any suggestions!

## Usage

A simple usage example generating an avatar based off the string `parlough` and storing it as
a PNG image on the file system.

```dart
import 'dart:io';

import 'package:blockify/blockify.dart';
import 'package:image/image.dart';

/// This example generates a rendered icon using most of the default parameter
/// values but setting the background as transparent. Then it proceeds to
/// encode the result as a PNG with the `image` package, and proceeds to store
/// the encoded PNG in a file named `parlough.png`.
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

```

**Generated image:**

![The generated image](https://github.com/parlough/blockify/blob/main/example/parlough.png)

## Features and bugs

Please file feature requests and bugs in the [issue tracker][tracker].

[tracker]: https://github.com/parlough/blockify
