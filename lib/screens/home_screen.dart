import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/news_model.dart';
import '../widgets/news_item_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService apiService;
  late Future<List<NewsModel>> newsFuture;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(
        '3646bcbb298542db98b297634666d561'); // Replace with your NewsAPI key
    newsFuture = apiService.getNews('default').then((newsList) {
      return newsList.map((news) => NewsModel.fromJson(news)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: FutureBuilder<List<NewsModel>>(
        future: newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final newsItem = snapshot.data![index];
                return NewsItemWidget(newsItem);
              },
            );
          }
        },
      ),
    );
  }
}
