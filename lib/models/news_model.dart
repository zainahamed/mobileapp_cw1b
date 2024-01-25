class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final bool isFavorite;
  final String publishedAt;  // Add this property

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    this.isFavorite = false,
    required this.publishedAt,  // Make sure to include this in the constructor
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      isFavorite: false,
      publishedAt: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'publishedAt': publishedAt,
    };
  }
}