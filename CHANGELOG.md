## 1.0.0

- Update minimum Dart SDK requirement to Dart 3.0
- No longer explicitly name `blockify.dart` library
- Require `package:crypto` 3.0.3 or greater
- **BREAKING**:
  - The primary color generation algorithm has changed, 
    resulting in new outputs if no `primaryColor` is specified
  - Require `package:image` 4.0.17 or greater, 
    which includes v4, a complete overhaul of the package
  - Accept `package:image`'s `Color` objects instead of integers
    for `backgroundColor` and `primaryColor`

## 0.2.0

- Update minimum SDK requirement to Dart 2.17
- Update dependencies to latest versions
- Prepare for use in Dart 3
- Update used linting and analysis options

## 0.1.0

- Initial preview release, supporting null safety.
