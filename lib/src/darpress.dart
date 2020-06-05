import 'dart:io';

import '../darpress.dart';
import './middleware/middleware_wrapper.dart';
import './route/darpress_router.dart';
import './route/route.dart';
import './route/routing.dart';
import 'http/converter/http_converter.dart';
import 'route/builder/router_builder.dart';
import 'route/route_methods.dart';

part 'darpress_impl.dart';

/// A Darpress app which contains routing.
abstract class Darpress extends RouteMethods<Darpress> {
  /// Creates a new app.
  factory Darpress() => _Darpress();

  /// Returns whether error handler is set.
  bool get hasErrorHandler;

  /// Add middleware for the same path but different HTTP methods by using a
  /// builder.
  ///
  /// ```dart
  /// void main() async {
  ///   final app = Darpress();
  ///   pp.builder('/users').get((request, response, next) async {
  ///     // send users data
  ///     await response.send('users data');
  ///   }).post((request, response, next) async {
  ///     // save user data
  ///     await response.send('user data');
  ///   }).put((request, response, next) async {
  ///     // update user data
  ///     await response.send('updated user data');
  ///   }).delete((request, response, next) async {
  ///     // delete user data
  ///     await response.send('user data delete success');
  ///   });
  ///   app.listen();
  /// }
  /// ```
  ///
  /// **Note**: The above code is equivalent to the below:
  ///
  /// ```dart
  /// void main() async {
  ///   final app = Darpress();
  ///
  ///   app.get('/users', (request, response, next) async {
  ///     // send users data
  ///     await response.send('users data');
  ///   });
  ///
  ///   app.post('/users', (request, response, next) async {
  ///     // save user data
  ///     await response.send('user data');
  ///   });
  ///
  ///   app.put('/users', (request, response, next) async {
  ///     // update user data
  ///     await response.send('updated user data');
  ///   });
  ///
  ///   app.delete('/users', (request, response, next) async {
  ///     // delete user data
  ///     await response.send('user data delete success');
  ///   });
  ///   app.listen();
  /// }
  /// ```
  RouterBuilder builder(String path);

  /// Closes the app. It will force to close the app if the [force] is set
  /// to true. By default it won't use force close.
  /// The [onClose] callback will be called after the app is closed, so that,
  /// you can close subscriptions and release resources from the memory, such as
  /// closing a database instance and so on.
  ///
  /// ```dart
  /// void main() async {
  ///   final app = Darpress();
  ///   // write the routes here.
  ///
  ///   // You may need some condition to stop the app. Otherwise, the app will
  ///   // be closed immediately after it started.
  ///   await app.close(onClose: () {
  ///     //TODO: Write your login here.
  ///   });
  /// }
  /// ```
  Future<void> close({bool force = false, void Function() onClose});

  /// Set custom error handler.
  /// ```dart
  /// void main() async {
  ///   final app = Darpress();
  ///   app.errorHandler((request, response, error, next) async {
  ///      print(error);
  ///      await next();
  ///   });
  /// }
  /// ```
  Darpress errorHandler(ErrorHandler errorHandler);

  /// It will start listening on the specified [port] number, or it will use
  /// 3000 as a default port number if it is not defined. Once the app is
  /// initialized, it will return the [HttpServer] instance.
  /// ```dart
  /// void main() async {
  ///   final app = Darpress();
  ///   app.get('test', (request, response, next) async {
  ///     response.send({'language': 'Dart'});
  ///   });
  ///
  ///   HttpServer server = await app.listen();
  ///   //Now you can use the server to do some other stuff.
  /// }
  /// ```
  Future<HttpServer> listen({int port});

  /// Sometimes you may want to use custom [HttpServer], so in that case, what
  /// you need to do is create the [HttpServer] by yourself and give it to the
  /// app so that you can use the routing and other features from this
  /// framework.
  ///```dart
  /// void main() async{
  ///   final app = Darpress();
  ///   app.get('test', (request, response, next) async {
  ///     response.send({'language': 'Dart'});
  ///   });
  ///
  ///   HttpServer httpServer = await HttpServer.bind(
  ///     InternetAddress.loopbackIPv4,
  ///     5000,
  ///   );
  ///
  ///   app.listenTo(httpServer);
  /// }
  /// ```
  void listenTo(HttpServer server);

  /// ```dart
  /// class UserRouter implements CustomRouter {
  ///   @override
  ///   void route(Router router) {
  ///     router.post('/users', _postUser);
  ///     router.get('/users', _getUsers);
  ///     // OR you can use the builder.
  ///     // router.route('/users').post(_postUser).get(_getUsers);
  ///   }
  ///
  ///   Future<void> _getUsers(Request request, Response response, next) async {
  ///     //TODO: write your logic here.
  ///     await response.send('some user data');
  ///   }
  ///
  ///   Future<void> _postUser(Request request, Response response, next) async {
  ///     //TODO: write your logic here.
  ///     await response.send('saved user data');
  ///   }
  ///  }
  ///
  ///  //Now you can use the router in your app.
  ///  void main() async{
  ///    final app = Darpress();
  ///    app.route(UserRouter());
  ///    await app.listen();
  ///    // OR you can use the shortcut like this.
  ///    // Darpress().route(UserRouter()).listen();
  ///  }
  /// ```
  Darpress route(CustomRouter router);

  /// Set a middleware on specific type of http method.
  /// [onMethod] is by default [Method.all]
  /// ```dart
  /// void main() async{
  ///   final app = Darpress();
  ///   app.use(
  ///     (request, response, next) async {
  ///       //TODO: write your logic here.
  ///       await next();
  ///     },
  ///     onMethod: Method.get,
  ///   );
  /// }
  /// ```
  Darpress use(Middleware middleware, {Method onMethod = Method.all});

  /// Set a middleware before the response is sent  on specific type of http
  /// method.
  /// [onMethod] is by default [Method.all]
  /// ```dart
  /// final app = Darpress();
  /// app.useOnResponse(
  ///   (request, response, next) async {
  ///     //TODO: write your logic here.
  ///     await next();
  ///   },
  ///   onMethod: Method.get,
  /// );
  /// ```
  Darpress useOnResponse(Middleware middleware, {Method onMethod = Method.all});
}
