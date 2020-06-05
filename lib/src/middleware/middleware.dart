import '../../darpress.dart';

typedef Next = Future<void> Function([dynamic error]);

typedef Middleware = Future<void> Function(
    Request request, Response response, Next next);

typedef ErrorHandler = Future<void> Function(
    Request request, Response response, dynamic error, Next next);
