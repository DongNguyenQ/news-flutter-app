import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_flutter_app/model/response/fetch_list_article_response.dart';

class NewsService {
  final apiKey = '75380bed6e374886a46fe10ead4a25d0';
  final baseUrl = 'https://newsapi.org/v2';
  Future<FetchListArticleResponse> fetchArticles(
      {String? keyword, int? page, int? pageSize}) async {
    print('KEY : $keyword');
    final url = Uri.parse(
        "$baseUrl/everything?q=$keyword&sortBy=publishedAt&apiKey=$apiKey&page=$page&pageSize=$pageSize"
      // "https://newsapi.org/v2/everything?q=tesla&sortBy=publishedAt&apiKey=75380bed6e374886a46fe10ead4a25d0&page=1&pageSize=10"
    );
    print('URL : ${url.path}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return FetchListArticleResponse.fromJson(body);
    } else {
      throw Exception(
          "Unable to perform request! ${response.statusCode} : ${response.body}");
    }
  }

  Future<FetchListArticleResponse> fetchTopHeadlines(
      {int? page, int? pageSize}) async {
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey&page=$page&pageSize=$pageSize");
    print('URL : ${url.path}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return FetchListArticleResponse.fromJson(body);
    } else {
      throw Exception(
          "Unable to perform request! ${response.statusCode} : ${response.body}");
    }
  }
}
