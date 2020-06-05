part of 'darpress.dart';

class _Darpress with Routing<Darpress> implements Darpress {
  final _router = DarpressRouter();
  final _errorHandlers = <ErrorHandler>[];
  final _responseMiddleware = <Middleware>[];
  final _requestMiddleware = <MiddlewareWrapper>[];

  HttpServer _httpServer;

  _Darpress() {
    super.router = _router;
  }

  @override
  bool get hasErrorHandler => _errorHandlers.isNotEmpty;

  @override
  RouterBuilder builder(String path) => _router.route(path);

  @override
  Future<void> close({bool force = false, void Function() onClose}) async {
    await _httpServer.close(force: force);
    onClose();
  }

  @override
  Darpress errorHandler(ErrorHandler errorHandler) {
    _errorHandlers.insert(0, errorHandler);
    return this;
  }

  @override
  Future<HttpServer> listen({int port}) async {
    _httpServer = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      port ?? 3000,
    );
    _listen();
    return _httpServer;
  }

  @override
  void listenTo(HttpServer server) {
    _httpServer = server;
    _listen();
  }

  @override
  Darpress route(CustomRouter customRouter) {
    customRouter.route(_router);
    return this;
  }

  @override
  Darpress use(Middleware middleware, {Method onMethod = Method.all}) {
    if (onMethod.isUnsupported() || onMethod.isAll() || onMethod == null) {
      final wrapper = MiddlewareWrapper(
        method: Method.all,
        middleware: middleware,
      );

      _requestMiddleware.add(wrapper);
      return this;
    }

    final wrapper = MiddlewareWrapper(method: onMethod, middleware: middleware);
    _requestMiddleware.add(wrapper);
    return this;
  }

  @override
  Darpress useOnResponse(Middleware middleware,
      {Method onMethod = Method.all}) {
    _responseMiddleware.add(middleware);
    return this;
  }

  HttpConverter _convertHttpRequest(HttpRequest httpRequest) {
    return HttpConverter(
      httpRequest: httpRequest,
      onSendResponse: _onSendResponse,
    );
  }

  Map<String, dynamic> _extractParams(String path, String requestPath) {
    final params = <String, dynamic>{};
    if (path.contains(':')) {
      final pathList = path.split('/');
      final requestPathList = requestPath.split('/');
      final paramKeys = pathList
          .where((s) => s.startsWith(':'))
          .map((s) => s.replaceAll(':', ''));

      for (var key in paramKeys) {
        final index = pathList.indexOf(':$key');
        params[key] = requestPathList.elementAt(index);
      }
    }
    return params;
  }

  List<Middleware> _getMiddlewares(Request request) {
    return _requestMiddleware
        .where((wrapper) =>
            wrapper.method.equals(request.method) || wrapper.method.isAll())
        .map((wrapper) => wrapper.middleware)
        .toList();
  }

  void _handleError(Request request, Response response, dynamic error) {
    response.send(error);
  }

  void _handleHttpRequest(HttpConverter httpConverter) async {
    final request = httpConverter.request;
    final response = httpConverter.response;
    final handlerMiddlewares = _router.handlerOf(
      request.uri.path,
      request.method,
    );

    if (handlerMiddlewares != null) {
      var next;
      var handlerIndex = 1;
      final middlwares = _getMiddlewares(request);
      final middlewareHandlers = middlwares
        ..addAll(handlerMiddlewares.values.first ?? []);
      request.params.addAll(
          _extractParams(handlerMiddlewares.keys.first, request.uri.path));

      next = ([error]) async {
        if (error != null) {
          _handleError(request, response, error);
        } else if (!response.isClosed()) {
          if (handlerIndex < middlewareHandlers.length) {
            final nextHandler = middlewareHandlers[handlerIndex];
            handlerIndex++;
            await nextHandler(request, response, next);
          } else {
            final error = 'Cannot ${request.method.name} ${request.uri.path}';
            _handleError(request, response, error);
          }
        }
      };

      try {
        await middlewareHandlers.first(request, response, next);
      } on Exception catch (error, stacktrace) {
        print('$error\n$stacktrace');
        _handleError(request, response, error);
      }
    } else {
      final error = 'Cannot ${request.method.name} ${request.uri.path}';
      _handleError(request, response, error);
    }
  }

  void _listen() {
    _httpServer.map(_convertHttpRequest).listen(_handleHttpRequest);
  }

  Future<void> _onSendResponse(
      {HttpRequest httpRequest, Request request, Response response}) async {
    while (_responseMiddleware.iterator.moveNext()) {}
    await httpRequest.response.close();

    /// notify on response middleware
    /// all pass the _sendResponseMethod to the last middleware to do the last
    /// operation
  }
}
