import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class ApiService {
  static const String _apiKey =
      '6c4f1118ddf5483eae67064ea329801f';

  static const String _baseUrl =
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(_baseUrl));

    print("STATUS CODE : ${response.statusCode}");
    print("BODY : ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List articles = data['articles'];

      return articles
          .map((e) => Article.fromJson(e))
          .toList();
    } else {
      throw Exception(response.body);
    }
  }
}