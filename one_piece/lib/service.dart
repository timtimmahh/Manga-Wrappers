import "dart:async";

import 'package:http/http.dart' as http;
import 'package:manga_base/http_service.dart';

import 'models.dart';

class OnePieceService extends HttpService {
  OnePieceService(http.Client client)
      : super(client, 'https://onepiecechapters.com');

  Future<SitePage> getPage(int id) => get(
      (result) =>
          result.parseJsonObject((jsonRoot) => SitePage.fromJson(jsonRoot)),
      unencodedPath: '/wp-json/wp/v2/pages/$id');

  Future<List<SitePage>> getPages() => get(
      (result) => List<SitePage>.from(result.parseJsonArray(
          (jsonRoot) => jsonRoot.map((model) => SitePage.fromJson(model)))),
      unencodedPath: '/wp-json/wp/v2/pages');

  Future<Chapter> getChapter(int id) => get(
      (result) =>
          result.parseJsonObject((jsonRoot) => Chapter.fromJson(jsonRoot)),
      unencodedPath: '/wp-json/wp/v2/posts/$id');

  Future<List<Chapter>> getChapters() => get(
      (result) => List<Chapter>.from(result.parseJsonArray(
          (jsonRoot) => jsonRoot.map((model) => Chapter.fromJson(model)))),
      unencodedPath: '/wp-json/wp/v2/posts');

  Future<MediaItem> getMediaItem(int id) => get(
      (result) =>
          result.parseJsonObject((jsonRoot) => MediaItem.fromJson(jsonRoot)),
      unencodedPath: '/wp-json/wp/v2/media/$id');

  Future<List<MediaItem>> getMedia() => get(
      (result) => List<MediaItem>.from(result.parseJsonArray(
          (jsonRoot) => jsonRoot.map((model) => MediaItem.fromJson(model)))),
      unencodedPath: '/wp-json/wp/v2/media');
}
