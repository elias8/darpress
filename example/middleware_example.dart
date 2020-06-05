import 'package:darpress/darpress.dart';

import 'color_mock.dart';

void main() async {
  final app = Darpress();
  app.get('/colors', (request, response, next) async {
    response.status(200).send(colors);
  });

  app.get(
    '/colors/:name',
    (request, response, next) async {
      print('Running color finder middleware...');
      final colorName = request.params['name'];
      final color = getColorByName(colorName);

      request.params['color'] = color;
      await next();
    },
    [
      (request, response, next) async {
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
    ],
  );

  await app.listen();
}
