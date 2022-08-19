/// Dartified: Life-saving helpers for working with JavaScript libraries when compiling Dart/Flutter to Web.

library dartified;

import 'dart:js';
import 'dart:async';

class Dartified {
  /// Checks if [value] doesn't need to be converted between JavaScript and Dart.
  static bool isBasicType(value) {
    return value == null ||
        value is num ||
        value is bool ||
        value is String ||
        value is DateTime;
  }

  /// Converts a Dart [object] to what can be passed to JavaScript.
  static dynamic jsify(Object object) {
    return isBasicType(object)
        ? object
        : object is Function
            ? allowInterop(object)
            : JsObject.jsify(object);
  }

  /// Converts a JavaScript [object] to what can be used in Dart.
  static T dartify<T>(dynamic object) {
    if (isBasicType(object)) {
      return object as T;
    }

    // If [object] is a JavaScript function, wrap it in a Dart closure that takes in a List parameter.
    if (object is JsFunction) {
      return ((List args) => object.apply(args)) as T;
    }

    // If [object] is a list/array, convert it items to Dart recursively.
    if (object is Iterable) {
      return object.map(dartify).toList() as T;
    }

    // Else, [object] is definitely a JavaScript object so get the keys and convert to Dart's [Map].
    return Map.fromIterable(
      context['Object'].callMethod('keys', [object]),
      value: (key) => dartify(object[key]),
    ) as T;
  }

  /// Converts a JavaScript Promise [object] to Dart's [Future] object.
  static Future<T> promiseToFuture<T>(JsObject object) {
    if (!object.instanceof(context['Promise'])) {
      throw StateError('$object is not a JavaScript Promise.');
    }

    final completer = Completer<T>();

    object.callMethod(
      'then',
      [
        (result) => completer.complete(result),
        (error) => completer.completeError(error ?? NullThrownError()),
      ],
    );

    return completer.future;
  }
}
