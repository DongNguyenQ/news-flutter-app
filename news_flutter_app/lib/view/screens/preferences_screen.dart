import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_flutter_app/repository/news_repository.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/utils/helper.dart';
import 'package:news_flutter_app/view/widgets/article_preference_item_view.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';
import 'package:news_flutter_app/view/widgets/custom_3rd_party_radio_button/button_text_style.dart';
import 'package:news_flutter_app/view/widgets/custom_3rd_party_radio_button/custom_radio_button.dart';
import 'package:news_flutter_app/viewmodel/preferences_viewmodel_bloc.dart';
import 'package:news_flutter_app/viewmodel/preferences_viewmodel_bloc_loadmore.dart';
import 'package:news_flutter_app/viewmodel/preferences_viewmodel_keyword_bloc.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewsService service = new NewsService();
    NewsRepository repository = new NewsRepositoryImpl(service);
    return MultiBlocProvider(
        providers: [
          BlocProvider<PreferencesKeywordBloc>(
            create: (BuildContext context) => PreferencesKeywordBloc()..add(FetchPreferencesKeywords()),
          ),
          BlocProvider<PreferencesArticlesBloc>(
            create: (BuildContext context) => PreferencesArticlesBloc(service, repository),
          ),
        ],
        child: PreferencesView(),
    );
  }
}

class PreferencesView extends StatefulWidget {
  const PreferencesView({Key? key}) : super(key: key);

  @override
  _PreferencesViewState createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrolling);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<PreferencesViewModel>(context);
    // vm.fetchArticle();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        // brightness: Brightness.light,
        title: AppText.h2Bitter('Preferences'),
        // backgroundColor: Colors.white,
        // elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            BlocConsumer<PreferencesKeywordBloc, PreferencesKeywordState>(
              listener: (BuildContext ctx, PreferencesKeywordState state) {
                if (state is FoundPreferencesKeywordListState) {
                  // context.read<PreferencesBloc>().add(FetchPreferencesArticle(keyword: state.getKeywords!.first.value));
                  context.read<PreferencesArticlesBloc>().add(FetchInitialArticle(state.getKeywords!.first.value));
                }
              },
              builder: (BuildContext ctx, PreferencesKeywordState state) {
                if (state is FoundPreferencesKeywordListState) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: CustomRadioButton(
                      elevation: 0,
                      enableShape: true,
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.black,
                      unSelectedBorderColor: Colors.black,
                      unSelectedColor: Theme.of(context).canvasColor,
                      buttonLables: state.getKeywordsLabel!,
                      buttonValues: state.getKeywordsValue!,
                      buttonTextStyle: ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 16)),
                      defaultSelected: state.getKeywords!.first.value,
                      radioButtonValue: (value) {
                        if (value is String) {
                          // context.read<PreferencesBloc>().add(FetchPreferencesArticle(keyword: value));
                          context.read<PreferencesArticlesBloc>().add(FetchInitialArticle(value));
                        }
                      },
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox(height: 20),
            BlocConsumer<PreferencesArticlesBloc, PreferencesArticlesState>(
              builder: (BuildContext ctx, PreferencesArticlesState state) {
                if (state.status == PreferencesStatus.failure && state.articles.length == 0) {
                  return _buildErrorView(error: state.errorMessage);
                }
                if (state.status == PreferencesStatus.initial || state.status == PreferencesStatus.loading) {
                  return CustomLoadingIndicator();
                }
                return Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (ctx, idx) {
                      if (state.status == PreferencesStatus.success && state.articles.isEmpty) {
                        return _buildNoData();
                      }
                      if (state.articles.length > 0) {
                        if (idx >= state.articles.length - 1)
                          return Column(
                            children: [
                              state.status == PreferencesStatus.failure
                                  ? _buildErrorView(error: 'Failled to load more')
                                  : CustomLoadingIndicator(),
                              SizedBox(height: 30,)
                            ],
                          );
                        if (state.hasReachedMax) {
                          return _buildReachedEndView();
                        }
                        return GestureDetector(
                          onTap: () {
                            ctx.beamTo(
                              ArticleDetailLocation()
                                ..state = BeamState(
                                  queryParameters: {
                                    'article': json.encode(state.articles[idx].toJson())
                                  },
                                  pathBlueprintSegments: ['articles'],
                                ),
                            );
                          },
                          child: ArticlePreferenceItemView(article: state.articles[idx]),
                        );
                      }
                      return SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: AppText.bodyBitter('Not handle'),
                      );
                    },
                    separatorBuilder: (ctx, idx) => SizedBox(height: 30),
                    itemCount: state.articles.length,
                  ),
                );
              },
              listener: (BuildContext ctx, PreferencesArticlesState state) {
                print('STATE : $state');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return Center(child: AppText.body('No articles found'));
  }

  Widget _buildErrorView({String? error}) {
    return Center(child: AppText.body(
        error != null && error.length > 0
            ? error : 'Failed to fetch articles'));
  }

  Widget _buildReachedEndView() {
    return Center(child: AppText.body('You have reached the end'));
  }

  void _onScrolling() {
    if (didScrollReachTheEnd(_scrollController)) {
      context.read<PreferencesArticlesBloc>().add(FetchMoreArticle());
    }
  }
}
