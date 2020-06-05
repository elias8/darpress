import 'package:darpress/darpress.dart';

import 'color_mock.dart';

void main() async {
  final app = Darpress();
  app.get('/colors', (request, response, next) async {
    response.status(200).send(colors);
  });

  app.get('/colors/:name', (request, response, next) async {
    final colorName = request.params['name'];
    final color = getColorByName(colorName);

    if (color == null) {
      response.status(404).send({'message': '$colorName not found.'});
    } else {
      response.status(200).send(color);
    }
  });

  await app.listen();
}
