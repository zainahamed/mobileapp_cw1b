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
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    apiService = ApiService('3646bcbb298542db98b297634666d561');
    searchController = TextEditingController();
    newsFuture = _fetchNews('default');
  }

  Future<List<NewsModel>> _fetchNews(String query) async {
    final newsList = await apiService.getNews(query);
    return newsList.map((news) => NewsModel.fromJson(news)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: FutureBuilder<List<NewsModel>>(
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
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onSubmitted: (query) {
                _updateNews(query);
              },
              decoration: InputDecoration(
                hintText: 'Search for news...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _updateNews(searchController.text);
            },
          ),
          SizedBox(width: 8.0), // Add some spacing between search and reset button
          ElevatedButton(
            onPressed: () {
              _resetNews();
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetNews() {
    setState(() {
      searchController.clear(); // Clear the search query
      newsFuture = _fetchNews('default'); // Fetch the default news list
    });
  }


  void _updateNews(String query) {
    setState(() {
      newsFuture = _fetchNews(query);
    });
  }
}
