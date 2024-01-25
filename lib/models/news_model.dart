class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final bool isFavorite;
  final String publishedAt;

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    this.isFavorite = false,
    required this.publishedAt,
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