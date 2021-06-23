import 'package:flutter/material.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';

class ArticleItemView extends StatelessWidget {
  final ArticleEntity article;
  const ArticleItemView({Key? key, required this.article}) : super(key: key);
  final double imageRatio = 4 / 3;
  final double verticleSpacing = 12;
  final double bodyPadding = 12;

  @override
  Widget build(BuildContext context) {
    print('ARTICLE : ${article.urlToImage} - ${article.title} - ${article.description}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
            aspectRatio: imageRatio,
            child: article.urlToImage != null ? CustomCachedNetworkImage(url: article.urlToImage!) : SizedBox()),
        SizedBox(height: verticleSpacing),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: bodyPadding),
            child: AppText.h3(article.title ?? "")),
        SizedBox(height: verticleSpacing),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: bodyPadding),
            child: AppText.body(article.description ?? ""))
      ],
    );
  }
}
