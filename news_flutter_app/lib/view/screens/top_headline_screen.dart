import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flutter_app/repository/news_repository.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/utils/helper.dart';
import 'package:news_flutter_app/view/widgets/article_item_view.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';
import 'package:news_flutter_app/viewmodel/top_headline_viewmodel.dart';

import '../../main.dart';

class TopHeadlineScreen extends StatelessWidget {
  const TopHeadlineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewsService service = new NewsService();
    NewsRepository repository = new NewsRepositoryImpl(service);
    return BlocProvider<TopHeadlinesBloc>(
        create: (BuildContext context) =>
          TopHeadlinesBloc(service, repository),
        child: TopHeadlineView()
    );
  }
}

class TopHeadlineView extends StatefulWidget {
  const TopHeadlineView({Key? key}) : super(key: key);

  @override
  _TopHeadlineViewState createState() => _TopHeadlineViewState();
}

class _TopHeadlineViewState extends State<TopHeadlineView> {
  final double articleVerticleSpacing = 28;
  final Key loadMoreReachTheEndKey = Key('loadMoreReachTheEndKey');
  final Key loadMoreFailed = Key('loadMoreFailed');
  final Key loadMoreLoading = Key('loadMoreLoading');
  final Key listViewTopHeadlines = Key('listViewTopHeadlines');

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrolling);
    _fetchInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: AppText.h2Bitter('Top Headlines'),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _refresh()
        ),
        child: BlocConsumer<TopHeadlinesBloc, TopHeadlinesState>(
          builder: (BuildContext ctx, TopHeadlinesState state) {
            if (state is FoundTopHeadlinesListState) {
              return ListView.separated(
                key: listViewTopHeadlines,
                controller: _scrollController,
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (ctx, idx) {
                  if (idx >= state.articles!.length - 1) {
                    if (state.hasReachedMax != null && state.hasReachedMax!) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Center(
                            child: AppText.captionBitter(
                                'You have reached the end',
                                key: loadMoreReachTheEndKey)),
                      );
                    }
                    if (state.errorLoadMore != null && state.errorLoadMore!.length > 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Center(
                            child: AppText.captionBitter(
                                'Failed to fetch more',
                                key: loadMoreFailed,
                            )),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: CustomLoadingIndicator(key: loadMoreLoading),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      ctx.beamTo(
                        ArticleDetailLocation()
                          ..state = BeamState(
                            queryParameters: {
                              'article': json.encode(state.articles![idx].toJson())
                            },
                            pathBlueprintSegments: ['articles'],
                          ),
                      );
                    },
                    child: ArticleItemView(article: state.articles![idx], key: Key('article-${idx}'),
                    ),
                  );
                },
                separatorBuilder: (ctx, idx) =>
                    SizedBox(height: articleVerticleSpacing),
                itemCount: state.articles!.length,
              );
            }
            if (state is LoadingTopHeadlinesState && state is InitialHeadlineState) {
              return CustomLoadingIndicator();
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
          listener: (BuildContext ctx, TopHeadlinesState state) {},
        ),
      )
    );
  }

  void _fetchInitialData() {
    context.read<TopHeadlinesBloc>().fetchInitial();
  }

  void _onScrolling() {
    if (didScrollReachTheEnd(_scrollController)) {
      context.read<TopHeadlinesBloc>().loadMore();
    }
  }

  void _refresh() {
    context.read<TopHeadlinesBloc>().loadMore(isRefresh: true);
  }
}
