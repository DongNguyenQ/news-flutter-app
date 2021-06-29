import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/source_entity.dart';
import 'package:news_flutter_app/utils/helper.dart';
import 'package:beamer/beamer.dart';
import 'package:news_flutter_app/view/shared/app_colors.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleEntity? article;
  final String? articleID;
  const ArticleDetailScreen({Key? key, this.article, this.articleID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArticleDetailView(article: article);
  }
}

class ArticleDetailView extends StatelessWidget {
  final ArticleEntity? article;
  const ArticleDetailView({Key? key, this.article}) : super(key: key);

  final double bodyPadding = 16;
  final double spacing = 16;
  final double imageRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                snap: true,
                floating: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    context.beamBack();
                  },
                ),
                expandedHeight: MediaQuery.of(context).size.width * 9 / 16,
                flexibleSpace: FlexibleSpaceBar(
                  background: AspectRatio(
                      aspectRatio: imageRatio,
                      child:
                      article!.urlToImage != null && article!.urlToImage!.length > 0
                          ? CustomCachedNetworkImage(url: article!.urlToImage!) : SizedBox()),
                  stretchModes: [StretchMode.zoomBackground],
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: bodyPadding),
              child: Column(
                children: [
                  SizedBox(height: spacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      article!.author != null
                          ? Expanded(
                            child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      size: 16, color: kcLightGreyColor),
                                  SizedBox(width: 4),
                                  Expanded(child:
                                    AppText.captionBitter(
                                      article!.author!,
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      // color: Colors.red[300]!,
                                    ),
                                  ),
                                ],
                              ),
                          )
                          : SizedBox(),
                      // AppText.body(DateFormat('kk:mm - dd/MM/yyyy')
                      //     .format(article!.publishedAt))
                          Expanded(child: AppText.captionBitter(
                            article!.publishedAt,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            align: TextAlign.end,
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 8),
                  AppText.subheadingBitter(article!.title ?? ""),
                  SizedBox(height: spacing),
                  AppText.bodyBitter(article!.description ?? ""),
                  SizedBox(height: spacing),
                  AppText.bodyBitter(article!.content ?? ""),
                  SizedBox(height: spacing),
                  SizedBox(height: spacing),
                  SizedBox(height: spacing),
                  article!.url != null
                      ? MaterialButton(
                          minWidth: 200,
                          height: 50,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey, width: 0.5)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText.bodyBitter('Full Article'),
                            ],
                          ),
                          onPressed: () {
                            launchURL(article!.url!);
                          },
                          color: Colors.transparent,
                        )
                      : SizedBox(),
                  SizedBox(height: spacing),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
