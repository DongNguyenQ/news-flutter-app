import 'package:flutter/material.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/model/keyword_entity.dart';

class PreferencesViewModel extends ChangeNotifier {
  List<ArticleEntity> articles = [];
  bool isLoading = false;
  final String defaultKeyword = 'bitcoin';
  final NewsService service = new NewsService();
  final List<KeyWordEntity> keys = [
    new KeyWordEntity('bitcoin', 'bitcoin'),
    new KeyWordEntity('apple', 'apple'),
    new KeyWordEntity('earthquake', 'earthquake'),
    new KeyWordEntity('animal', 'animal'),
  ];

  List<KeyWordEntity> get getListKeys => keys;

  void fetchArticle({String? keyword}) async {
    this.isLoading = true;
    notifyListeners();
    String? finalKeyword = keyword;
    if (finalKeyword == null || finalKeyword.length == 0) {
      finalKeyword = defaultKeyword;
    }
    final data = await service.fetchArticles(keyword: defaultKeyword);
    if (data.status == "ok") {
      this.articles = data.articles!;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    print('PreferencesViewModel was disposed.');
    super.dispose();
  }
}
