import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/source_entity.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/view/screens/article_detail_screen.dart';
import 'package:news_flutter_app/view/widgets/article_item_view.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';
import 'package:news_flutter_app/viewmodel/top_headline_viewmodel.dart';
import 'package:news_flutter_app/viewmodel/top_headline_viewmodel_bloc.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class TopHeadlineScreen extends StatelessWidget {
  const TopHeadlineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewsService service = new NewsService();
    return BlocProvider<TopHeadlinesBloc>(
        create: (BuildContext context) => TopHeadlinesBloc(service)..add(FetchTopHeadlinesArticle()),
        child: TopHeadlineView()
    );
    return ChangeNotifierProvider(
      create: (context) => TopHeadlineViewModel(),
      child: TopHeadlineView(),
    );
  }
}

class TopHeadlineView extends StatelessWidget {
  const TopHeadlineView({Key? key}) : super(key: key);
  final double articleVerticleSpacing = 28;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TopHeadlinesBloc, TopHeadlinesState>(
        builder: (BuildContext ctx, TopHeadlinesState state) {
          if (state is FoundTopHeadlinesListState) {
            return ListView.separated(
              itemBuilder: (ctx, idx) => GestureDetector(
                  onTap: () {
                    // ctx.beamToNamed('/articles?articleID=1');
                    ctx.beamTo(
                      ArticleDetailLocation()
                        ..state = BeamState(
                          queryParameters: {
                            'article': json.encode(state.articles![idx].toJson())
                          },
                            pathBlueprintSegments: [
                              'articles'
                            ],
                        ),
                    );
                  },
                  child: ArticleItemView(article: state.articles![idx])),
              separatorBuilder: (ctx, idx) =>
                  SizedBox(height: articleVerticleSpacing),
              itemCount: state.articles!.length,
            );
          }
          if (state is LoadingTopHeadlinesState && state is InitialPreferenceState) {
            return CircularProgressIndicator();
          }
          if (state is ErrorTopHeadlinesState) {
            return Center(
              child: AppText.body(state.error),
            );
          }
          if (state is NotFoundTopHeadlinesState) {
            return Center(
              child: AppText.body('No data'),
            );
          }
          return SizedBox();
        },
        listener: (BuildContext ctx, TopHeadlinesState state) {

        },
      )
    );
    // final vm = Provider.of<TopHeadlineViewModel>(context);
    // vm.fetchArticles();
    // return Scaffold(
    //   body: vm.getStatus ? CircularProgressIndicator() : ListView.separated(
    //     itemBuilder: (ctx, idx) => GestureDetector(
    //         onTap: () {
    //           // vm.dispose();
    //           ctx.beamToNamed('/articles?articleID=1');
    //           // Navigator.of(context).push(MaterialPageRoute(
    //           // builder: (BuildContext context) => ArticleDetailScreen()));
    //         },
    //         child: ArticleItemView(article: vm.getArticles[idx])),
    //     separatorBuilder: (ctx, idx) =>
    //         SizedBox(height: articleVerticleSpacing),
    //     itemCount: vm.getArticles.length,
    //   ),
    // );
  }
}
