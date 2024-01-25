import 'dart:io';

import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


class NewsItemWidget extends StatelessWidget {
  final NewsModel newsItem;

  NewsItemWidget(this.newsItem);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[100], // Slight grey background color
        elevation: 2.0, // Add elevation for a card-like effect
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: GestureDetector(
          onTap: () {
            _launchUrl(newsItem.url);
          },
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
                  icon: Icon(Icons.bookmark_outline),
                  onPressed: () {
                    // Implement logic to save the news
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (Platform.isAndroid) {
        // For Android, try using the 'intent' URL scheme with Chrome, fallback to any browser
        await launch('intent://$url#Intent;scheme=http;package=com.android.chrome;end');
      } else {
        // For iOS and others, use the 'http' scheme
        await launch(url);
      }
    } on PlatformException catch (e) {
      if (e.code == 'ACTIVITY_NOT_FOUND') {
        // If Chrome is not available, try launching without specifying the browser package
        await launch(url);
      } else {
        print('Error launching URL: $e');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
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
        color: Colors.grey[300],
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
