import '../../darpress.dart';

/// Defines all available http methods.
abstract class RouteMethods<T> {
  /// Handles any Http method that matches the defined [path].
  T all(String path, Middleware handler, [List<Middleware> nextHandlers]);

  /// Handles Http method DELETE on [path] route.
  T delete(String path, Middleware handler, [List<Middleware> nextHandlers]);

  /// Handles Http method GET on [path] route.
  T get(String path, Middleware handler, [List<Middleware> nextHandlers]);

  /// Handles Http method PATH on [path] route.
  T patch(String path, Middleware handler, [List<Middleware> nextHandlers]);

  /// Handles Http method POST on [path] route.
  T post(String path, Middleware handler, [List<Middleware> nextHandlers]);

  /// Handles Http method PUT on [path] route.
  T put(String path, Middleware handler, [List<Middleware> nextHandlers]);
}
