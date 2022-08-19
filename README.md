# dartified

Life-saving helpers for working with JavaScript libraries when compiling Dart/Flutter to Web.

## Features

The functions included in this library will only work when you are compiling a Dart/Flutter project to Web.

Below are the included helpers so far:

- `isBasicType(value)` - Checks if a value doesn't need to be converted between JavaScript and Dart.
- `dartify(dynamic object)` - Converts a JavaScript object to what can be used in Dart.
- `jsify(Object object)` - Converts a Dart object to what can be passed to JavaScript.
- `promiseToFuture(JsObject object)` - Converts a JavaScript Promise object to Dart's Future object.

## Usage

```dart
import 'dart:js' as js;

import 'package:dartified/dartified.dart';

/// An example using browser's fetch.
Future<void> main() async {
  try {
    var response = await Dartified.promiseToFuture(
      js.context.callMethod(
        Dartified.jsify('fetch'),
        [
          Dartified.jsify(
            'https://api.github.com/repos/javascript-tutorial/en.javascript.info/commits',
          ),
        ],
      ),
    );

    var json =
        await Dartified.promiseToFuture<String>(response.callMethod('json'));

    print(Dartified.dartify(json));
  } catch (e) {
    print('error: $e');
  }
}
```
