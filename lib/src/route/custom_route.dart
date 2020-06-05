import '../../darpress.dart';

/// Defining all routes in a single main method could be very bad and make your
/// code unreadable. If you want to keep the routers separated by the route path
/// or even by the feature,  you may want to define them in their class.
// ignore: one_member_abstracts
abstract class CustomRouter {
  /// ```dart
  /// class UserRouter implements CustomRouter {
  ///  @override
  ///  void route(Router router) {
  ///    router.post('/users', _postUser);
  ///    router.get('/users', _getUsers);
  ///    // OR you can use the builder.
  ///    // router.route('/users').post(_postUser).get(_getUsers);
  ///  }
  ///
  ///  Future<void> _getUsers(Request request, Response response, next) async {
  ///    //TODO: write your logic here.
  ///    await response.send('some user data');
  ///  }
  ///
  ///  Future<void> _postUser(Request request, Response response, next) async {
  ///    //TODO: write your logic here.
  ///    await response.send('saved user data');
  ///  }
  ///  }
  ///
  /// //Now you can use the router in the app.
  ///  final app = Darpress();
  ///  app.route(UserRouter());
  /// ```
  void route(Router router);
}
