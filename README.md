# Darpress
#### WARNING: This is highly experimental.
Darpress is easy to use, lightweight, annotation free, and no source generation server framework for dart inspired by 
expressjs.

## Usage

A simple usage example:

```dart
import 'package:darpress/darpress.dart';

void main() async{
  final app = Darpress();
  app.post('/todos', (request, response, next) async{
  //TODO: write your logic here.
  await response.send('some response');
  });
  
  app.post('/todos', (request, response, next) async{
  //TODO: write your logic here
  await response.send({'key': 'value'});
  });
    
  final server = await app.listen(); // default port number is 3000
  // you can define the port number if you want.
  // final server = await app.listen(port: 5000);
}
```

As the routes for your app increases, you may want to use a `CustomRouter`. It will make your code more
organized and easily readable.

```dart
import 'package:darpress/darpress.dart';

class UserRouter implements CustomRouter {
  @override
  void route(Router router) {
    router.post('/users', _postUser);
    router.get('/users', _getUsers);
    // OR you can use the builder.
    // router.route('/users').post(_postUser).get(_getUsers);
  }

  Future<void> _getUsers(Request request, Response response, next) async {
    //TODO: write your logic here.
    await response.send('some user data');
  }

  Future<void> _postUser(Request request, Response response, next) async {
    //TODO: write your logic here.
    await response.send('saved user data');
  }
 }
```
Now you can use the `UserRouter` in your app.

```dart
void main() async{
   final app = Darpress();
   app.route(UserRouter());
   final server = await app.listen();
   // OR you can use the shortcut like this.
   // Darpress().route(UserRouter()).listen();
 }
```

You can add multiple middlewares on a route.
```dart
void main() async {
  final app = Darpress();
  app.get('/colors', (request, response, next) async {
    print('Running the first middleware..');
    await next();
  }, [
    (request, response, next) async {
      print('Running the second middleware..');
      await next();
    },
    (request, response, next) async {
      print('Running the third middleware..');
      await next();
    },
    (request, response, next) async {
      print('Running the last middleware..');
      response.send('Middleware example.');
    }
  ]);
  
  app.listen();
}
```
## Examples

- [Examples](https://github.com/Elias8/darpress/tree/master/example) - an example of how to use a custom router and 
middleares.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Elias8/darpress/issues

### Maintainers

 * [Elias Andualem](https://github.com/Elias8)
