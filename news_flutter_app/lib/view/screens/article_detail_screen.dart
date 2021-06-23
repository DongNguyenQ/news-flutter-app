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
                    // Navigator.of(context).pop();
                  },
                ),
                expandedHeight: MediaQuery.of(context).size.width * 9 / 16,
                flexibleSpace: FlexibleSpaceBar(
                  background: AspectRatio(
                      aspectRatio: imageRatio,
                      child:
                          CustomCachedNetworkImage(url: article!.urlToImage!)),
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
                                  Expanded(child: AppText.body(article!.author!, maxLines: 1, overflow: TextOverflow.clip,)),
                                ],
                              ),
                          )
                          : SizedBox(),
                      // AppText.body(DateFormat('kk:mm - dd/MM/yyyy')
                      //     .format(article!.publishedAt))
                      Expanded(child: AppText.body(article!.publishedAt, maxLines: 1, overflow: TextOverflow.clip, align: TextAlign.end,))
                    ],
                  ),
                  SizedBox(height: 8),
                  AppText.subheading(article!.title ?? "",
                      align: TextAlign.justify),
                  SizedBox(height: spacing),
                  AppText.body(article!.description ?? ""),
                  SizedBox(height: spacing),
                  AppText.body(article!.content ?? ""),
                  SizedBox(height: spacing),
                  article!.url != null ? MaterialButton(
                      onPressed: () {
                        launchURL(article!.url!);
                      },
                      child: AppText.body('Link gốc')) : SizedBox(),
                  SizedBox(height: spacing),
                ],
              ),
            ),
          )),

      // extendBodyBehindAppBar: true,
      // appBar: new AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       context.beamBack();
      //     },
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       AspectRatio(
      //           aspectRatio: imageRatio,
      //           child: CustomCachedNetworkImage(url: article1.urlToImage)),
      //       SizedBox(height: spacing),
      //       Padding(
      //         padding: EdgeInsets.symmetric(horizontal: bodyPadding),
      //         child: Column(
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Row(
      //                   children: [
      //                     Icon(Icons.edit, size: 16, color: kcLightGreyColor),
      //                     SizedBox(width: 4),
      //                     AppText.caption(article1.author),
      //                   ],
      //                 ),
      //                 AppText.caption(DateFormat('kk:mm - dd/MM/yyyy')
      //                     .format(article1.publishedAt))
      //               ],
      //             ),
      //             SizedBox(height: 8),
      //             AppText.subheading(article1.title, align: TextAlign.justify),
      //             SizedBox(height: spacing),
      //             AppText.body(article1.description, align: TextAlign.justify),
      //             SizedBox(height: spacing),
      //             AppText.body(article1.content, align: TextAlign.justify),
      //             SizedBox(height: spacing),
      //             MaterialButton(
      //                 onPressed: () {
      //                   launchURL(article1.url);
      //                 },
      //                 child: AppText.body('Link gốc')),
      //             SizedBox(height: spacing),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
