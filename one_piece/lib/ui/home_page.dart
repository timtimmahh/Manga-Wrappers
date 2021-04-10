import 'package:dartkt/dartkt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:manga_base/manga_base.dart';
import 'package:one_piece/info.dart';

import '../models.dart';

class OnePieceHomePage extends HomePage<OnePieceManga> {
  OnePieceHomePage({required OnePieceManga manga}) : super(manga: manga);

  @override
  Widget getDetailsScreen() => OnePieceDetailsScreen(manga: manga);
}

class OnePieceDetailsScreen extends HomeDetailsStateScreen<OnePieceManga> {
  OnePieceDetailsScreen({required OnePieceManga manga}) : super(manga: manga);

  @override
  State createState() => OnePieceDetailsState(manga: manga);
}

class OnePieceDetailsState
    extends HomeDetailsState<OnePieceManga, HomePageData> {
  OnePieceDetailsState({required OnePieceManga manga}) : super(manga: manga);

  @override
  Future<HomePageData> getData() => Future.wait(Iterable.generate(3, (index) {
        switch (index) {
          case 0:
            return manga.service.getPages();
          case 1:
            return manga.service.getChapters();
          case 2:
            return manga.service.getMedia();
          default:
            return Future.value(List.empty());
        }
      })).then((value) => HomePageData(value[0] as List<SitePage>,
          value[1] as List<Chapter>, value[2] as List<MediaItem>));

  @override
  List<Widget> getLayoutChildren(BuildContext context, HomePageData snapshot) {
    var bannerUrl = snapshot.third.length > 2
        ? snapshot.third.find((it) => it.id == 3131)?.original.sourceUrl
        : null;
    /*(snapshot.third.length > 2
        ? snapshot.third.find((it) => it.id == 3131)?.original.sourceUrl
        : null)?.let((obj) => Image.network(obj)) ??
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        );*/
    var introText = (snapshot.first.length > 2
            ? snapshot.first.find((it) => it.page == 'intro')?.content
            : null) ??
        'Intro text not available.';
    /*Text((snapshot.first.length > 2
        ? snapshot.first.find((it) => it.page == 'intro')?.content : null) ?? 'Intro text not available.');*/
    return <Widget>[
      Html(
        data: '''
<img src="$bannerUrl" alt="One Piece banner image"/>
</br>
$introText
''',
        onLinkTap: (url, context, attrs, element) {
          print("Opening $url...");
        },
        onImageTap: (url, context, attrs, element) {
          print(url);
        },
        onImageError: (exception, stackTrace) {
          print(exception);
        },
        /*customImageRenders: {
          networkSourceMatcher(domains: ["flutter.dev"]):
              (context, attributes, element) {
            return FlutterLogo(size: 36);
          },
          networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
            headers: {"Custom-Header": "some-value"},
            altWidget: (alt) => Text(alt!),
            loadingWidget: () => Text("Loading..."),
          ),
          // On relative paths starting with /wiki, prefix with a base url
              (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
          networkImageRender(
              mapUrl: (url) => "https://upload.wikimedia.org" + url),
          // Custom placeholder image for broken links
          networkSourceMatcher(): networkImageRender(altWidget: (_) => FlutterLogo()),
        },*/
      )
    ];
  }
}
