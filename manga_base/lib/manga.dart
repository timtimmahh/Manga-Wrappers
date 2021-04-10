import 'package:http/http.dart' as http;

import 'http_service.dart';
import 'ui/page.dart';

abstract class Manga<S extends HttpService, D> {
  static http.Client httpClient = http.Client();
  final S service;
  late D mangaData;

  Manga(this.service);

  String get title;

  HomePage get homePage;
}
