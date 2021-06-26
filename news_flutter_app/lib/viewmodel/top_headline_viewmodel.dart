// import 'package:flutter/foundation.dart';
// import 'package:news_flutter_app/model/article_entity.dart';
// import 'package:news_flutter_app/repository/news_service.dart';
//
// class TopHeadlineViewModel extends ChangeNotifier {
//   List<ArticleEntity> _articles = [];
//   bool _isBusy = false;
//
//   List<ArticleEntity> get getArticles => _articles;
//   bool get getStatus => _isBusy;
//
//   final NewsService service = new NewsService();
//
//   Future<void> fetchArticles() async {
//     setBusy(true);
//     final results = await service.fetchTopHeadlines(page: 1, pageSize: 10);
//     this._articles = results.articles!;
//     notifyListeners();
//     setBusy(false);
//   }
//
//   void setBusy(bool isBusy) {
//     this._isBusy = isBusy;
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     print('TopHeadlineViewModel was disposed.');
//     super.dispose();
//   }
// }
