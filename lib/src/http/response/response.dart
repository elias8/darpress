import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../http_object.dart';

part 'response_impl.dart';

/// A [Response] object that would be sent.
abstract class Response extends HttpObject {
  /// Create a new [Response].
  factory Response({
    @required HttpResponse response,
    @required void Function(Response response) onSend,
  }) =>
      _Response(response: response, onSend: onSend);

  /// It will clear cookies.
  Response clearCookie();

  /// Set the response content type.
  Response contentType(ContentType contentType);

  /// Returns whether the response is sent.
  bool isClosed();

  /// Same as `send(data)` method but this one only sends json data.
  void json(Map<String, dynamic> json);

  /// Removes a specific value for a header name.
  Response removeHeader(String name);

  /// Sends the data and closes the response object.
  void send(dynamic data);

  /// Adds a header named [name] to the response.
  ///
  /// If a header named [name] is already added, the new value of header [name]
  /// will be replaced.
  Response setHeader(String name, Object value);

  /// Sets the status repose.
  Response status(int statusCode);
}
