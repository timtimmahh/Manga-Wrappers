import 'package:flutter/material.dart';
import 'package:manga_base/manga_base.dart';
import 'package:manga_wrappers/manga.dart';

import 'ui/manga_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Manga? _selectedManga;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free Mangas',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue),
      themeMode: ThemeMode.dark,
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('MangasListPage'),
            child: MangaListScreen(
              title: 'Manga',
              mangas: mangaList,
              onTapped: _handleMangaTapped,
            ),
          ),
          if (_selectedManga != null) _selectedManga!.homePage
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          // Update the list of pages by setting _selectedBook to null
          setState(() {
            _selectedManga = null;
          });

          return true;
        },
      ),
    );
  }

  void _handleMangaTapped(Manga manga) {
    setState(() {
      _selectedManga = manga;
    });
  }
}
