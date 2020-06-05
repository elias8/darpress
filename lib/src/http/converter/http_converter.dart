import 'dart:io';

import 'package:meta/meta.dart';

import '../../../darpress.dart';
import '../http.dart';


typedef OnSendResponse = Future<void> Function({
  @required Request request,
  @required Response response,
  @required HttpRequest httpRequest,
});

/// Converts [HttpRequest] to [Request] and [Response] object.
class HttpConverter {
  final OnSendResponse _onSend;
  final HttpRequest _httpRequest;

  Request _request;
  Response _response;

  /// Create a new [HttpConverter].
  HttpConverter({
    @required HttpRequest httpRequest,
    @required OnSendResponse onSendResponse,
  })  : _onSend = onSendResponse,
        _httpRequest = httpRequest;

  /// Returns the converted [Request] object.
  Request get request {
    if (_request != null) return _request;
    _request = _createRequest();
    return _request;
  }

  /// Returns the converted [Response] object.
  Response get response {
    if (_response != null) return _response;
    _response = _createResponse();
    return _response;
  }

  Request _createRequest() => Request(httpRequest: _httpRequest);

  Response _createResponse() =>
      Response(response: _httpRequest.response, onSend: _onSen);

  Future<void> _onSen(Response response) async {
    await _onSend(
      request: request,
      response: response,
      httpRequest: _httpRequest,
    );
  }
}
