import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_flutter_app/model/response/fetch_list_article_response.dart';
import 'package:news_flutter_app/utils/const.dart';

class NewsService {
  Future<FetchListArticleResponse> fetchArticles(
      {String? keyword, int? page, int? pageSize}) async {
    final url = Uri.parse(
        "$baseUrl/everything?q=$keyword&sortBy=publishedAt&apiKey=$apiKey&page=$page&pageSize=$pageSize"
    );
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
        "$baseUrl/top-headlines?country=us&apiKey=$apiKey&page=$page&pageSize=$pageSize");
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
