part of 'response.dart';

class _Response implements Response {
  bool _isClosed = false;
  final Function _onSend;
  final HttpResponse _response;

  _Response({
    @required HttpResponse response,
    @required Function(Response response) onSend,
  })  : _response = response,
        _onSend = onSend;

  @override
  HttpConnectionInfo get connectionInfo => _response.connectionInfo;

  @override
  int get contentLength => _response.contentLength;

  @override
  List<Cookie> get cookies => _response.cookies;

  @override
  HttpHeaders get headers => _response.headers;

  @override
  Response clearCookie() {
    _response.cookies.clear();
    return this;
  }

  @override
  Response contentType(ContentType contentType) {
    _response.headers.contentType = contentType;
    return this;
  }

  @override
  bool isClosed() => _isClosed;

  @override
  void json(Map<String, dynamic> json) {
    if (_isClosed) {
      throw Exception('Tried to write after the response is closed');
    }

    contentType(ContentType.json);
    _write(jsonEncode(json));
    _close();
    _onSend(this);
  }

  @override
  Response removeHeader(String name) {
    _response.headers.removeAll(name);
    return this;
  }

  @override
  void send(dynamic data) {
    if (_isClosed) {
      throw Exception('Tried to write after the response is closed');
    }

    if (data is Map|| data is List<Map>) {
      contentType(ContentType.json);
      data = jsonEncode(data);
    }
    _write(data);
    _close();
    _onSend(this);
  }

  @override
  Response setHeader(String name, Object value) {
    _response.headers.add(name, value);
    return this;
  }

  @override
  Response status(int statusCode) {
    _response.statusCode = statusCode;
    return this;
  }

  void _close() => _isClosed = true;

  void _write(dynamic data) => _response.write(data);
}
