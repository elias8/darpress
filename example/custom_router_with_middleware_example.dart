import 'package:darpress/darpress.dart';

import 'color_mock.dart';

void main() async {
  final app = Darpress();
  app.route(ColorRouter());
  await app.listen();
}

class ColorRouter implements CustomRouter {
  @override
  void route(Router router) {
    router.get('/colors', _getColors);
    router.get('/colors/:name', _findColor, [_sendColor]);
  }

  Future<void> _findColor(Request request, Response response, next) async {
    print('Running color finder middleware...');
    final colorName = request.params['name'];
    final color = getColorByName(colorName);

    request.params['color'] = color;
    await next();
  }

  Future<void> _getColors(Request request, Response response, next) async {
    await response.send(colors);
  }

  Future<void> _sendColor(Request request, Response response, next) async {
    print('Running color response sender middleware...');
    final color = request.params['color'];
    if (color == null) {
      await response
          .status(404)
          .send({'message': '${request.params['name']} not found.'});
    } else {
      await response.status(200).send(color);
    }
  }
}
