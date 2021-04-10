import 'package:dartkt/dartkt.dart';

class SitePage {
  int id;
  String title;
  String content;
  String page;

  SitePage(this.id, this.title, this.content, this.page);

  SitePage.fromJson(Map<String, dynamic> /*JsonObject*/ json)
      : id = json['id'],
        title = json['title']['rendered']
        /*json(['title', 'rendered'])*/,
        content = json['content']['rendered']
        /*json(['content', 'rendered'])*/,
        page = json['slug'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'page': page,
      };
}

class Chapter {
  int id;
  String title;
  String excerpt;
  String? upcomingDate;
  List<String> content;

  Chapter(this.id, this.title, this.excerpt, this.upcomingDate, this.content);

  Chapter.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title =
            (json['title']['rendered'] /*(['title', 'rendered'])*/ as String)
                .removeFirst('One Piece - '),
        excerpt = (json['excerpt']
                ['rendered'] /*(['excerpt', 'rendered'])*/ as String)
            .removeAll(RegExp(r'[\n\t]|<[\w/!-\s]+>|\s+=+>[\w\s]+')),
        content = (json['content']
                ['rendered'] /*(['content', 'rendered'])*/ as String)
            .removeAll(r'[\n\t]'.asRegExp())
            .match(r'src="([\w:/.%-]+\.png)">')
            .mapNotNull((e) => e.group(1))
            .toList() {
    upcomingDate = excerpt.toLowerCase().contains('upcoming')
        ? excerpt
            .match(r'iframe src="[\w:/.%-]+\/[a-zA-Z]+([\w:-]+)"')
            .first
            .group(1)
        : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'excerpt': excerpt,
        'upcomingDate': upcomingDate,
        'content': content,
      };
}

class MediaItem {
  int id;
  String slug;
  String title;
  MediaImage original;
  Map<String, MediaImage> images;

  MediaItem(this.id, this.slug, this.title, this.original, this.images);

  MediaItem.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        slug = json['slug'] as String,
        title = json['title']['rendered'] /*(['title', 'rendered'])*/ as String,
        original = MediaImage(
            json['media_details']['file'] /*(['media_details', 'file'])*/,
            json['media_details']['width'] /*(['media_details', 'width'])*/,
            json['media_details']['height'] /*(['media_details', 'height'])*/,
            json['mime_type'],
            json['source_url']),
        images = (json['media_details']['sizes'] as Map<String,
                dynamic>) /*<JsonObject>(['media_details', 'sizes'])*/
            .map<String, MediaImage>(
                (key, value) => MapEntry(key, MediaImage.fromJson(value)));

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'title': title,
        'original': original.toJson(),
        'images': images.map((key, value) => MapEntry(key, value.toJson())),
      };
}

class MediaImage {
  String file;
  int width;
  int height;
  String mimeType;
  String sourceUrl;

  MediaImage(this.file, this.width, this.height, this.mimeType, this.sourceUrl);

  MediaImage.fromJson(Map<String, dynamic> json)
      : file = json['file'],
        width = json['width'],
        height = json['height'],
        mimeType = json['mime_type'],
        sourceUrl = json['source_url'];

  Map<String, dynamic> toJson() => {
        'file': file,
        'width': width,
        'height': height,
        'mime_type': mimeType,
        'source_url': sourceUrl,
      };
}
