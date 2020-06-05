part of 'darpress_router.dart';

/// A class which contains details about specific route.
class Route {
  /// A route path.
  final String path;
  
  /// RegEx representation of the path.
  final String regEx;
  
  /// Type of the HTTP method.
  final Method method;

  /// Create route detail.
  const Route({
    @required this.path,
    @required this.regEx,
    @required this.method,
  });
}

class _DarpressRouterImpl implements DarpressRouter {
  final _middlewares = <MiddlewareWrapper>[];
  final _routes = HashMap<Route, List<Middleware>>();

  @override
  List<MiddlewareWrapper> get middlewares => _middlewares;

  @override
  DarpressRouter all(String path, Middleware handler, [List nextHandlers]) {
    return _addRouter(path, Method.all, handler, nextHandlers);
  }

  @override
  DarpressRouter delete(String path, Middleware handler,
      [List<Middleware> nextHandlers]) {
    return _addRouter(path, Method.delete, handler, nextHandlers);
  }

  @override
  DarpressRouter get(String path, Middleware handler,
      [List<Middleware> nextHandlers]) {
    return _addRouter(path, Method.get, handler, nextHandlers);
  }

  @override
  Map<String, List<Middleware>> handlerOf(String path, Method method) {
    final middlewares = _middlewares
        .where((wrapper) =>
            wrapper.method.equals(method) || wrapper.method.isAll())
        .map((wrapper) => wrapper.middleware)
        .toList();

    final key = _routes.keys.firstWhere((route) {
      final methodMatch = route.method.equals(method);
      final pathMatch = RegExp(route.regEx).hasMatch(path);
      final matched = pathMatch && methodMatch;
      return matched;
    }, orElse: () => null);

    if (!_routes.containsKey(key)) return null;

    middlewares.insertAll(middlewares.length, _routes[key]);
    return {key.path: middlewares};
  }

  @override
  DarpressRouter patch(String path, Middleware handler, [List nextHandlers]) {
    return _addRouter(path, Method.patch, handler, nextHandlers);
  }

  @override
  DarpressRouter post(String path, Middleware handler,
      [List<Middleware> nextHandlers]) {
    return _addRouter(path, Method.post, handler, nextHandlers);
  }

  @override
  DarpressRouter put(String path, Middleware handler,
      [List<Middleware> nextHandlers]) {
    return _addRouter(path, Method.put, handler, nextHandlers);
  }

  @override
  RouterBuilder route(String path) => RouterBuilder(path: path, router: this);

  @override
  DarpressRouter sub(String path, DarpressRouter router) {
    _routes.forEach((route, handler) {
      final nPath = pathToRegExp(path).pattern.replaceAll('\$', '');
      final oPath = route.regEx.replaceFirst('^', '');
      final newPath = '$nPath$oPath';
      final newRoute = Route(path: path, regEx: newPath, method: route.method);
      _routes[newRoute] = handler;
    });
    middlewares.addAll(router.middlewares);
    return this;
  }

  @override
  DarpressRouter use(Middleware middleware, {Method onMethod}) {
    onMethod ??= Method.all;
    if (onMethod.isUnsupported()) {
      throw ArgumentError(
          'Unable to add middleware on unsupported method ${onMethod.name}.');
    }

    final wrapper = MiddlewareWrapper(middleware: middleware, method: onMethod);
    _middlewares.add(wrapper);
    return this;
  }

  DarpressRouter _addRouter(String path, Method method, Middleware handler,
      List<Middleware> nextHandlers) {
    final pattern = pathToRegExp(path).pattern;
    final handlers = <Middleware>[]
      ..add(handler)
      ..addAll(nextHandlers ?? []);

    final route = Route(path: path, regEx: pattern, method: method);
    _routes[route] = handlers;
    return this;
  }
}
