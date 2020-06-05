/// Supported Http Methods
enum Method {
  /// Http method ALL
  all,

  /// Http method GET
  get,

  /// Http method POST
  post,

  /// Http method PUT
  put,

  /// Http method PATCH
  patch,

  /// Http method DELETE
  delete,

  /// Http method UNSUPPORTED
  unsupported,
}

/// Converts Http methods from a given string to predefined custom Http method
/// constants.
class MethodConverter {
  /// Returns predefined Http Method from the give string. The provided string
  /// will first converted to uppercase before it is mapped.
  static Method fromString(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Method.get;
      case 'PUT':
        return Method.put;
      case 'POST':
        return Method.post;
      case 'PATCH':
        return Method.patch;
      case 'DELETE':
        return Method.delete;
      default:
        return Method.unsupported;
    }
  }
}

/// Applies easy to use methods on predefined Http methods to check their value.
extension MethodChecker on Method {
  /// Check if the given method is equal or not.
  bool equals(Method method) => this == method;

  /// Returns true if the method is ALL.
  bool isAll() => this == Method.all;

  /// Returns true if the method is GET.
  bool isGet() => this == Method.get;

  /// Returns true if the method is POST.
  bool isPost() => this == Method.post;

  /// Returns true if the method is PUT.
  bool isPut() => this == Method.put;

  /// Returns true if the method is PATCH.
  bool isPatch() => this == Method.patch;

  /// Returns true if the method is DELETE.
  bool isDelete() => this == Method.delete;

  /// Returns true if the method is UNSUPPORTED.
  bool isUnsupported() => this == Method.unsupported;

  /// Returns the method in string format.
  String get name => toString().split('.').last;
}
