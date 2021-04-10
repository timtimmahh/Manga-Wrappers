import 'dart:async';
import 'dart:convert';

import 'package:dartkt/dartkt.dart';
import 'package:http/http.dart' as http;

extension HttpResponse on http.Response {
  R parseJsonObject<R>(R creator(Map<String, dynamic> jsonRoot)) {
    var json = jsonDecode(body);
    // print(json);
    return creator(json /*JsonValue.fromJson(body) as JsonObject*/);
  }

  R parseJsonArray<R>(R creator(List<dynamic> jsonRoot)) {
    var json = jsonDecode(body) as List<dynamic>;
    // print(json);
    return creator(json /*JsonValue.fromJson(body) as JsonArray*/);
  }
}

extension FutureResponse on Future<http.Response> {
  Future<R> thenHandle<R>(R onResult(http.Response response)) =>
      then((value) => value.statusCode == 200
          ? onResult(value)
          : throw Exception('Failed to load ${value.request?.url}'));
}

abstract class HttpService {
  http.Client _client;
  String _baseUrl;
  bool _isSecure;

  HttpService(this._client, String baseUrl)
      : _baseUrl = baseUrl.substringAfterLast('://'),
        _isSecure = baseUrl.startsWith('https://');

  Uri _makeUri(String unencodedPath, Map<String, dynamic>? queryParameters) =>
      _isSecure
          ? Uri.https(_baseUrl, unencodedPath, queryParameters)
          : Uri.http(_baseUrl, unencodedPath, queryParameters);

  Future<R> get<R>(R onResult(http.Response response),
          {String unencodedPath = '/',
          Map<String, dynamic>? queryParameters}) async =>
      onResult(await _client.get(_makeUri(unencodedPath, queryParameters)));

  Future<R> post<R>(R onResult(http.Response response),
          {String unencodedPath = '/',
          Map<String, dynamic>? queryParameters}) async =>
      onResult(await _client.post(_makeUri(unencodedPath, queryParameters)));
}
