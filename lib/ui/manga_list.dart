import 'package:flutter/material.dart';
import 'package:manga_base/manga_base.dart';

class MangaListScreen extends StatelessWidget {
  final String title;
  final List<Manga> mangas;
  final ValueChanged<Manga> onTapped;

  MangaListScreen(
      {required this.title, required this.mangas, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: [
          for (var manga in mangas)
            ListTile(
              leading: Icon(Icons.book),
              title: Text(manga.title),
              onTap: () => onTapped(manga),
            )
        ],
      ),
    );
  }
}
