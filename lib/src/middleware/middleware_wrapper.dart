import 'package:meta/meta.dart';

import '../../darpress.dart';

/// A wrapper for [Method] and [Middleware].
class MiddlewareWrapper {
  /// The Http request method.
  final Method method;

  /// Request handler middleware.
  final Middleware middleware;

  /// Create new middleware wrapper.
  const MiddlewareWrapper({
    @required this.method,
    @required this.middleware,
  });
}
