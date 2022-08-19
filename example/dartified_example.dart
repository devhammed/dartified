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
