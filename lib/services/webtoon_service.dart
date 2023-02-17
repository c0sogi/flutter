import 'dart:convert';
import 'package:http/http.dart';

class ApiFetcher {
  static final ApiFetcher _instance = ApiFetcher._createSingleton();
  ApiFetcher._createSingleton();
  factory ApiFetcher({required String scheme, required String host}) {
    _instance.host = host;
    _instance.scheme = scheme;
    return _instance;
  }
  String? host, scheme;

  Future<T> fetch<T>(
      {required String path,
      required Function({required Map<String, dynamic> json}) fromJson}) async {
    final Response res = await get(
      Uri(
        scheme: ApiFetcher._instance.scheme,
        host: ApiFetcher._instance.host,
        path: path,
      ),
    );
    late final T instance;
    res.statusCode == 200
        ? instance = fromJson(json: jsonDecode(res.body))
        : throw Exception("Fetching failed");
    return instance;
  }

  Future<List<T>> fetchList<T>(
      {required String path,
      required Function({required Map<String, dynamic> json}) fromJson}) async {
    final Response res = await get(
      Uri(
        scheme: ApiFetcher._instance.scheme,
        host: ApiFetcher._instance.host,
        path: path,
      ),
    );
    late final List<T> instances;
    res.statusCode == 200
        ? instances = [
            for (var json in jsonDecode(res.body)) fromJson(json: json)
          ]
        : throw Exception("Fetching list failed");
    return instances;
  }
}
