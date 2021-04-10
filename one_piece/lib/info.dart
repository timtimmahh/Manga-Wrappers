import 'package:dartkt/dartkt.dart';
import 'package:manga_base/manga_base.dart';

import 'models.dart';
import 'service.dart';
import 'ui/home_page.dart';

typedef HomePageData = KTTriple<List<SitePage>, List<Chapter>, List<MediaItem>>;

class OnePieceManga extends Manga<OnePieceService, HomePageData> {
  OnePieceManga() : super(OnePieceService(Manga.httpClient));

  @override
  String get title => 'One Piece';

  @override
  HomePage get homePage => OnePieceHomePage(manga: this);
}
