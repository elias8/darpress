import 'package:meta/meta.dart';

import '../../../darpress.dart';
import '../darpress_router.dart';

part 'router_builder_impl.dart';

/// A route builder.
abstract class RouterBuilder {
  /// Create a builder for provided [path].
  factory RouterBuilder({
    @required String path,
    @required DarpressRouter router,
  }) =>
      _RouterBuilder(path: path, router: router);

  /// [Method.delete] handler middleware.
  RouterBuilder delete(Middleware handler, [List<Middleware> nextHandlers]);

  /// [Method.get] handler middleware.
  RouterBuilder get(Middleware handler, [List<Middleware> nextHandlers]);

  /// [Method.patch] handler middleware.
  RouterBuilder patch(Middleware handler, [List<Middleware> nextHandlers]);

  /// [Method.post] handler middleware.
  RouterBuilder post(Middleware handler, [List<Middleware> nextHandlers]);

  /// [Method.put] handler middleware.
  RouterBuilder put(Middleware handler, [List<Middleware> nextHandlers]);
}
