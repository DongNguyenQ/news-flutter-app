import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/view/widgets/article_preference_item_view.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';
import 'package:news_flutter_app/view/widgets/custom_3rd_party_radio_button/button_text_style.dart';
import 'package:news_flutter_app/view/widgets/custom_3rd_party_radio_button/custom_radio_button.dart';
import 'package:news_flutter_app/viewmodel/preferences_viewmodel_bloc.dart';
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<PreferencesBloc>(
            create: (BuildContext context) => PreferencesBloc(service),
          ),
          BlocProvider<PreferencesKeywordBloc>(
            create: (BuildContext context) => PreferencesKeywordBloc()..add(FetchPreferencesKeywords()),
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
        brightness: Brightness.light,
        title: Text(
          'Preferences',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            BlocConsumer<PreferencesKeywordBloc, PreferencesKeywordState>(
              listener: (BuildContext ctx, PreferencesKeywordState state) {
                if (state is FoundPreferencesKeywordListState) {
                  context.read<PreferencesBloc>().add(FetchPreferencesArticle(keyword: state.getKeywords!.first.value));
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
                          context.read<PreferencesBloc>().add(FetchPreferencesArticle(keyword: value));
                        }
                      },
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox(height: 20),
            BlocConsumer<PreferencesBloc, PreferencesState>(
              builder: (BuildContext ctx, PreferencesState state) {
                print('STATE : $state');
                if (state is FoundPreferencesListState) {
                  return Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (ctx, idx) => GestureDetector(
                          onTap: () {
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
                          child: ArticlePreferenceItemView(article: state.articles![idx])),
                      separatorBuilder: (ctx, idx) => SizedBox(height: 12),
                      itemCount: state.articles!.length,
                    ),
                  );
                }
                if (state is LoadingPreferenceState) {
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50,),
                        CircularProgressIndicator(color: Colors.black,)
                      ],
                    ),
                  );
                }
                if (state is NotFoundPreferencesState) {
                  return Center(
                    child: AppText.body('No data'),
                  );
                }
                if (state is ErrorPreferenceState) {
                  return Center(
                    child: AppText.body(state.error)
                  );
                }
                return SizedBox();
              },
              listener: (BuildContext ctx, PreferencesState state) {
                print('STATE : $state');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onScrolling() {
    bool _isReachBottom;
    if (!_scrollController.hasClients) {
      _isReachBottom = false;
    } else {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      _isReachBottom = currentScroll >= (maxScroll * 0.9);
    }
    if (_isReachBottom) {
      //fetch more data
    }
  }
}
