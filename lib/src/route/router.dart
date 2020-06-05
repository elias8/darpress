import '../../darpress.dart';
import 'builder/router_builder.dart';
import 'darpress_router.dart';
import 'route_methods.dart';

/// Http request router.
abstract class Router extends RouteMethods<Router> {
  /// Returns a [RouterBuilder].
  RouterBuilder route(String path);

  /// Create a sub route under [path].
  DarpressRouter sub(String path, DarpressRouter router);

  /// Set a middleware which only be used on this route.
  DarpressRouter use(Middleware middleware, {Method onMethod});
}
