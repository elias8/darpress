part of 'router_builder.dart';

class _RouterBuilder implements RouterBuilder {
  final String _path;
  final DarpressRouter _router;

  const _RouterBuilder({
    @required String path,
    @required DarpressRouter router,
  })  : _path = path,
        _router = router;

  @override
  RouterBuilder delete(Middleware handler, [List nextHandlers]) {
    _router.delete(_path, handler, nextHandlers);
    return this;
  }

  @override
  RouterBuilder get(Middleware handler, [List nextHandlers]) {
    _router.get(_path, handler, nextHandlers);
    return this;
  }

  @override
  RouterBuilder patch(Middleware handler, [List nextHandlers]) {
    _router.patch(_path, handler, nextHandlers);
    return this;
  }

  @override
  RouterBuilder post(Middleware handler, [List nextHandlers]) {
    _router.post(_path, handler, nextHandlers);
    return this;
  }

  @override
  RouterBuilder put(Middleware handler, [List nextHandlers]) {
    _router.put(_path, handler, nextHandlers);
    return this;
  }
}
