import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beamer/beamer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/view/screens/article_detail_screen.dart';
import 'package:news_flutter_app/view/screens/preferences_screen.dart';
import 'package:news_flutter_app/view/screens/profile_screen.dart';
import 'package:news_flutter_app/view/screens/top_headline_screen.dart';
import 'package:news_flutter_app/view/shared/app_styles.dart';
import 'package:news_flutter_app/viewmodel/profile_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    initialPath: '/${RouteInformation[Routes.top_headline]}',
    locationBuilder: SimpleLocationBuilder(
      routes: {
        '/*': (context, _) {
          final beamerKey = GlobalKey<BeamerState>();

          return Scaffold(
            body: Beamer(
              key: beamerKey,
              routerDelegate: BeamerDelegate(
                locationBuilder: BeamerLocationBuilder(
                  beamLocations: [
                    TopHeadlineLocation(),
                    PreferencesLocation(),
                    ProfileLocation(),
                    ArticleDetailLocation()
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBarWidget(
              beamerKey: beamerKey,
            ),
          );
        }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final w700BitterFont = GoogleFonts.bitter(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: Colors.black
    );
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: MaterialApp.router(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            brightness: Brightness.light,
            titleTextStyle: subheadingStyleBitter,
            textTheme: TextTheme(

            )
          ),
          primaryColor: Colors.black,
          buttonColor: Colors.black,
          backgroundColor: Colors.white,
          primaryTextTheme: TextTheme(
            headline6: w700BitterFont,
          ),
          textTheme: TextTheme(
            subtitle1: w700BitterFont.apply(color: Colors.black),
            headline6: w700BitterFont.apply(color: Colors.black),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerDelegate: routerDelegate,
        routeInformationParser: BeamerParser(),
        backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
      ),
    );
  }
}

class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({required this.beamerKey});

  final GlobalKey<BeamerState> beamerKey;

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    final BeamLocation currentLocation =
        widget.beamerKey.currentState!.currentBeamLocation;
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      currentIndex: currentLocation is TopHeadlineLocation
          ? 0
          : currentLocation is PreferencesLocation
              ? 1
              : 2,
      items: [
        BottomNavigationBarItem(label: 'Headline', icon: Icon(Icons.book)),
        BottomNavigationBarItem(
            label: 'Preferences', icon: Icon(Icons.article)),
        BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.login)),
      ],
      onTap: (index) => setState(() =>
          widget.beamerKey.currentState?.routerDelegate.beamToNamed(index == 0
              ? '/${RouteInformation[Routes.top_headline]}'
              : index == 1
                  ? '/${RouteInformation[Routes.preferences]}'
                  : '/${RouteInformation[Routes.profile]}')),
    );
  }
}

class TopHeadlineLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    List<BeamPage> pages = [];
    if (state.uri.pathSegments
        .contains(RouteInformation[Routes.top_headline])) {
      pages.add(
        new BeamPage(
          key: ValueKey(RouteInformation[Routes.top_headline]),
          title: 'Headline',
          child: TopHeadlineScreen(),
        ),
      );
    }
    return pages;
  }

  @override
  List get pathBlueprints => [
        '/${RouteInformation[Routes.top_headline]}',
      ];
}

class PreferencesLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    List<BeamPage> pages = [];
    if (state.uri.pathSegments.contains(RouteInformation[Routes.preferences])) {
      pages.add(
        new BeamPage(
          key: ValueKey(RouteInformation[Routes.preferences]),
          title: 'Preference',
          child: PreferencesScreen(),
        ),
      );
    }
    return pages;
  }

  @override
  List get pathBlueprints => [
        '/${RouteInformation[Routes.preferences]}',
      ];
}

class ProfileLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    List<BeamPage> pages = [];
    if (state.uri.pathSegments.contains(RouteInformation[Routes.profile])) {
      pages.add(
        new BeamPage(
          key: ValueKey(RouteInformation[Routes.profile]),
          title: 'Profile',
          child: ProfileScreen(),
        ),
      );
    }
    return pages;
  }

  @override
  List get pathBlueprints => ['/${RouteInformation[Routes.profile]}'];
}

class ArticleDetailLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    List<BeamPage> pages = [];
    if (state.uri.pathSegments
        .contains(RouteInformation[Routes.article_detail])) {
      String article = state.queryParameters['article']!;
      ArticleEntity articleEntity = ArticleEntity.fromJson(json.decode(article));
      pages.add(
        new BeamPage(
          key:
              ValueKey('${RouteInformation[Routes.article_detail]}-${articleEntity.source!.id ?? articleEntity.source!.name}'),
          title: 'Profile',
          child: ArticleDetailScreen(article: articleEntity),
        ),
      );
    }
    return pages;
  }

  @override
  List get pathBlueprints => ['/${RouteInformation[Routes.article_detail]}'];
}

// class LoginLocation extends BeamLocation {
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     List<BeamPage> pages = [];
//     if (state.uri.pathSegments
//         .contains(RouteInformation[Routes.article_detail])) {
//       final articleID = state.queryParameters['articleID'];
//       pages.add(
//         new BeamPage(
//           key: ValueKey('${RouteInformation[Routes.login]}'),
//           title: 'login',
//           child: ArticleDetailScreen(articleID: articleID),
//         ),
//       );
//     }
//     return pages;
//   }

//   @override
//   List get pathBlueprints => ['/${RouteInformation[Routes.login]}'];
// }

final Map<Routes, String> RouteInformation = {
  Routes.top_headline: 'headline',
  Routes.preferences: 'preferences',
  Routes.profile: 'profile',
  Routes.article_detail: 'articles',
  // Routes.login: 'login'
};

enum Routes { top_headline, preferences, profile, article_detail, login }
