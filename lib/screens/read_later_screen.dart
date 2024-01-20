import 'package:flutter/material.dart';
import '../models/news_model.dart';

class ReadLaterScreen extends StatefulWidget {
  final List<NewsModel> readLaterNews;

  ReadLaterScreen(this.readLaterNews);

  @override
  _ReadLaterScreenState createState() => _ReadLaterScreenState();
}

class _ReadLaterScreenState extends State<ReadLaterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Later'),
      ),
      body: widget.readLaterNews.isEmpty
          ? Center(child: Text('No articles marked for reading later.'))
          : ListView.builder(
        itemCount: widget.readLaterNews.length,
        itemBuilder: (context, index) {
          final newsItem = widget.readLaterNews[index];
          return ListTile(
            title: Text(newsItem.title),
            subtitle: Text(newsItem.description),
            // Add more UI elements based on your data structure
          );
        },
      ),
    );
  }
}
