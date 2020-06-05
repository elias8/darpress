import 'dart:io';

import '../../darpress.dart';

/// A base class for [Request] and [Response].
abstract class HttpObject {
  /// Returns the connection info.
  HttpConnectionInfo get connectionInfo;

  /// Returns the content length.
  int get contentLength;

  /// Returns the [cookies].
  List<Cookie> get cookies;

  /// Returns the [headers].
  HttpHeaders get headers;
}
