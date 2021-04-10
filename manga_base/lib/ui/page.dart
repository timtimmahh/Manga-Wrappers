import 'package:flutter/material.dart';
import 'package:manga_base/manga_base.dart';

abstract class HomePage<M extends Manga> extends Page {
  final M manga;

  HomePage({required this.manga}) : super(key: ValueKey(manga));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => getDetailsScreen(),
    );
  }

  Widget getDetailsScreen();
}

abstract class HomeDetailsStateScreen<M extends Manga> extends StatefulWidget {
  final M manga;

  HomeDetailsStateScreen({required this.manga});

  @override
  State createState();
}

abstract class HomeDetailsState<M extends Manga, D>
    extends State<HomeDetailsStateScreen> {
  final M manga;
  late Future<D> _data;

  HomeDetailsState({required this.manga});

  PreferredSizeWidget makeAppBar(String title) => AppBar(title: Text(title));

  List<Widget> getLayoutChildren(BuildContext context, D snapshot);

  @override
  void initState() {
    super.initState();
    this._data = getData().then((value) {
      manga.mangaData = value;
      return value;
    });
  }

  Future<D> getData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(manga.title)),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: FutureBuilder<D>(
          future: _data,
          builder: (context, snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = getLayoutChildren(context, snapshot.requireData);
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            );
          },
        )
        /*Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Text(manga.title, style: Theme
                  .of(context)
                  .textTheme
                  .headline6)
            ],
          ],
        )*/
        ,
      ),
    );
  }
}
