class NewsModel{
  final int id;
  final int author_id;
  final String title;
  final String content;
  final String kategori_id;
  final String thumbnail;

  NewsModel({required this.id, required this.author_id, required this.title, required this.content, required this.kategori_id, required this.thumbnail});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
     id: json['id'] ?? 0,
    author_id: json['author_id'] ?? 0,
    title: json['title']?.toString() ?? '',
    content: json['content']?.toString() ?? '',
    kategori_id: json['kategori_id']?.toString() ?? '', // Pastikan jadi String jika di UI butuh String
    thumbnail: json['thumbnail']?.toString() ?? '',
    );
  }
}