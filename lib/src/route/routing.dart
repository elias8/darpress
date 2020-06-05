import '../../darpress.dart';
import 'darpress_router.dart';
import 'route_methods.dart';

mixin Routing<T extends RouteMethods> implements RouteMethods<T> {
  DarpressRouter _router;

  @override
  T all(String path, Middleware handler, [List nextHandlers]) {
    _router.all(path, handler, nextHandlers);
    return this as T;
  }

  @override
  T delete(String path, Middleware handler, [List<Middleware> nextHandlers]) {
    _router.delete(path, handler, nextHandlers);
    return this as T;
  }

  @override
  T get(String path, Middleware handler, [List<Middleware> nextHandlers]) {
    _router.get(path, handler, nextHandlers);
    return this as T;
  }

  set router(DarpressRouter router) {
    _router = router;
  }

  @override
  T patch(String path, Middleware handler, [List nextHandlers]) {
    _router.patch(path, handler, nextHandlers);
    return this as T;
  }

  @override
  T post(String path, Middleware handler, [List<Middleware> nextHandlers]) {
    _router.post(path, handler, nextHandlers);
    return this as T;
  }

  @override
  T put(String path, Middleware handler, [List<Middleware> nextHandlers]) {
    _router.put(path, handler, nextHandlers);
    return this as T;
  }
}
