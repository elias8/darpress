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
    router.get('/colors/:name', _getColor);
  }

  Future<void> _getColor(Request request, Response response, next) async {
    final colorName = request.params['name'];
    final color = getColorByName(colorName);

    if (color == null) {
      response.status(404).send({'message': '$colorName not found.'});
    } else {
      response.status(200).send(color);
    }
  }

  Future<void> _getColors(Request request, Response response, next) async {
    await response.send(colors);
  }
}
