abstract interface class ApiClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? query});

  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  });

  Future<dynamic> put(String path, {dynamic body, Map<String, dynamic>? query});

  Future<dynamic> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  });

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  });

  Future<dynamic> postFormData(
    String path, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  });
}
