import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/model/article_entity.dart';

import 'common_ui.dart';

class ArticlePreferenceItemView extends StatelessWidget {
  const ArticlePreferenceItemView({Key? key, required this.article}) : super(key: key);
  final double imageRatio = 1;
  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: imageRatio,
            child: article.urlToImage != null && article.urlToImage!.length > 0 ?
                CustomCachedNetworkImage(
                    url: article.urlToImage!,
                    fit: BoxFit.cover,
                    radius: 10,
                ) : SizedBox()
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.headline(article.title ?? "", maxLines: 3, overflow: TextOverflow.clip),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: AppText.caption(article.author ?? "", maxLines: 1, overflow: TextOverflow.clip,)),
                    Expanded(child: AppText.caption(article.publishedAt ?? "", maxLines: 1, overflow: TextOverflow.clip, align: TextAlign.end,))
                  ],
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
