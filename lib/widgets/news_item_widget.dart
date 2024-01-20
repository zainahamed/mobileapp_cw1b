import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsModel newsItem;

  NewsItemWidget(this.newsItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100], // Slight grey background color
      elevation: 2.0, // Add elevation for a card-like effect
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: _buildNewsImage(newsItem.imageUrl),
        title: Text(newsItem.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              'Published on: ${_formatPublishedDate(newsItem.publishedAt)}',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                // Implement logic to mark as favorite
              },
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // Implement logic to save the news
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsImage(String? imageUrl) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: imageUrl != null
          ? BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      )
          : BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  String _formatPublishedDate(String? publishedAt) {
    try {
      if (publishedAt != null) {
        DateTime date = DateTime.parse(publishedAt);
        return '${date.day}/${date.month}/${date.year}';
      } else {
        return 'N/A';
      }
    } catch (e) {
      return 'N/A';
    }
  }

}
