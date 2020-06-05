part of 'request.dart';

class _Request implements Request {
  final HttpRequest _httpRequest;

  @override
  Map<String, dynamic> params;

  _Request({@required HttpRequest httpRequest})
      : _httpRequest = httpRequest,
        params = {};

  @override
  // TODO: implement body
  Future<dynamic> get body async {
    final content = await utf8.decoder.bind(_httpRequest).join();
    try {
      return jsonDecode(content);
    } on Exception {
      return content;
    }
  }

  @override
  Stream<List<int>> get bodyAsStream => _httpRequest;

  @override
  HttpConnectionInfo get connectionInfo => _httpRequest.connectionInfo;

  @override
  int get contentLength => _httpRequest.contentLength;

  @override
  List<Cookie> get cookies => _httpRequest.cookies;

  @override
  HttpHeaders get headers => _httpRequest.headers;

  @override
  Method get method => MethodConverter.fromString(_httpRequest.method);

  @override
  String get protocolVersion => _httpRequest.protocolVersion;

  @override
  Map<String, String> get queryParams => uri.queryParameters;

  @override
  Uri get uri => _httpRequest.uri;
}
