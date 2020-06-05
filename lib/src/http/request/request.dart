import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../../../darpress.dart';
import '../http_object.dart';

part 'request_impl.dart';

/// A [Request] object which container details about the request.
abstract class Request extends HttpObject {
  /// Returns the request [params].
  Map<String, dynamic> params;

  /// Create new [Request] object.
  factory Request({@required HttpRequest httpRequest}) =>
      _Request(httpRequest: httpRequest);

  /// Returns the request body.
  Future<dynamic> get body;

  /// Returns the request body as a [Stream].
  Stream<List<int>> get bodyAsStream;

  /// Returns the request [Method].
  Method get method;

  /// Returns the [protocolVersion].
  String get protocolVersion;

  /// Returns the query params.
  Map<String, String> get queryParams;

  /// Returns the request [uri].
  Uri get uri;
}
