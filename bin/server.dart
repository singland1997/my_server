import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Response _pageNotFoundHandler(Request request) {
  return Response.notFound('Page not found');
}

Response _rootHandler(Request request) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Response _jsonHandler(Request request) {
  final data = jsonDecode(File('films.json').readAsStringSync());
  return Response.ok(
    jsonEncode(data),
    headers: {'Content-Type': 'application/json'},
  );
}

main() {
  final app = Router();

  app.get('/', _rootHandler);
  app.get('/echo/<message>', _echoHandler);
  app.get('/json', _jsonHandler);
  app.all('/<ignored|.*>', _pageNotFoundHandler);

  serve(app, 'localhost', 8080);
  print('Server listening on 8080');
}
