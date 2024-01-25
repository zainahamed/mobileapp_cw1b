import 'package:flutter/material.dart';
import '../models/news_model.dart';

class FavoritesScreen extends StatefulWidget {
  final List<NewsModel> favoriteNews;

  FavoritesScreen(this.favoriteNews);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: widget.favoriteNews.isEmpty
          ? Center(child: Text('No favorite news yet.'))
          : ListView.builder(
              itemCount: widget.favoriteNews.length,
              itemBuilder: (context, index) {
                final newsItem = widget.favoriteNews[index];
                return ListTile(
                  title: Text(newsItem.title),
                  subtitle: Text(newsItem.description),
          );
        },
      ),
    );
  }
}
