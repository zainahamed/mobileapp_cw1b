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
  String selectedCategory = 'All';
  String selectedSortOption = 'relevance'; // Initialize with the default sort option
  String sortBy = 'default';

  @override
  void initState() {
    super.initState();
    apiService = ApiService('3646bcbb298542db98b297634666d561');
    searchController = TextEditingController();
    newsFuture = _fetchNews(selectedCategory, sortBy);
    _resetNews(); // Add this line to trigger the reset when the app loads
  }

  Future<List<NewsModel>> _fetchNews(String query, String sortBy) async {
    final newsList = await apiService.getNews(query, sortBy);
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
          _buildFilterChips(),
          SizedBox(height: 8.0),
          _buildSortingHeader(),
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

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.0,
      children: [
        for (var category in ['All', 'Books', 'Culture', 'Entertainment', 'Fashion', 'Food', 'Health', 'Internet', 'Politics', 'Space', 'Sports', 'World'])
          ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            onSelected: (selected) {
              _onCategorySelected(selected, category);
            },
            backgroundColor: selectedCategory == category ? Colors.blue : Colors.white,
            selectedColor: Colors.blue,
            labelStyle: TextStyle(
              color: selectedCategory == category ? Colors.white : Colors.blue,
            ),
            elevation: selectedCategory == category ? 4.0 : 1.0,
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: selectedCategory == category ? 0.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
      ],
    );
  }

  Widget _buildSortingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'News Feed',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _showSortingOptions(context);
            },
            child: Text('Sort By'),
          ),
    ),

      ],
    );
  }

  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortingOption('Relevance'),
            _buildSortingOption('Popularity'),
            _buildSortingOption('Published Date'),
          ],
        );
      },
    );
  }

  Widget _buildSortingOption(String option) {
    return ListTile(
      title: Text(option),
      onTap: () {
        _updateSortingOption(option.toLowerCase());
        Navigator.pop(context);
      },
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

  void _updateSortingOption(String option) {
    setState(() {
      selectedSortOption = option;
      sortBy = option == 'relevance' ? 'default' : option.toLowerCase();
      newsFuture = _fetchNews(selectedCategory, sortBy);
    });
  }

  void _updateNews(String query) {
    setState(() {
      selectedCategory = 'All'; // Reset category to 'All'
      newsFuture = _fetchNews(query, sortBy);
    });
  }

  void _resetNews() {
    setState(() {
      searchController.clear(); // Clear the search query
      selectedCategory = 'All'; // Reset category to 'All'
      newsFuture = _fetchNews('default', sortBy); // Fetch the default news list
    });
  }

  void _onCategorySelected(bool selected, String category) {
    setState(() {
      if (selected) {
        // If the category is selected, update the news list with the selected category
        selectedCategory = category;
        newsFuture = _fetchNews(category.toLowerCase(), sortBy);
      } else {
        // If the category is unselected, reset to default news list
        selectedCategory = 'All';
        newsFuture = _fetchNews('default', sortBy);
      }
      searchController.clear(); // Clear the search query when a category is selected
    });
  }
}
