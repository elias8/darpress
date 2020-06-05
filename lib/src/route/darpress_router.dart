import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../../darpress.dart';
import '../middleware/middleware_wrapper.dart';
import 'builder/router_builder.dart';

part 'darpress_router_impl.dart';

/// Router used internally by the framework.
abstract class DarpressRouter extends Router {
  /// Create a new Router.
  factory DarpressRouter() => _DarpressRouterImpl();

  /// Returns list of registered middlewares.
  List<MiddlewareWrapper> get middlewares;

  /// Returns handler middlewares of specified [path] and [method] if path and
  /// method is registered.
  Map<String, List<Middleware>> handlerOf(String path, Method method);
}
