import 'package:flutter/material.dart';
import 'package:news_flutter_app/ui/screens/article_detail_screen.dart';
import 'package:news_flutter_app/ui/screens/preferences_screen.dart';
import 'package:news_flutter_app/ui/screens/profile_screen.dart';
import 'package:news_flutter_app/ui/screens/top_headline_screen.dart';
import 'package:beamer/beamer.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentScreenIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routes: {
//         '/headline': (context) => TopHeadlineScreen(),
//         '/preferences': (context) => PreferencesScreen(),
//         '/profile': (context) => ProfileScreen()
//       },
//       home: Scaffold(
//         body: Center(
//           child: SizedBox(),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _currentScreenIndex,
//           selectedItemColor: Color(0xFF334192),
//           unselectedItemColor: Colors.grey,
//           onTap: (index) {
//             switch (index) {
//               case 0:
//                 Navigator.pushNamed(context, "/first");
//                 break;
//               case 1:
//                 Navigator.pushNamed(context, "/second");
//                 break;
//             }
//           },
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HEADLINE'),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.calendar_today), label: "PREFERENCES"),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.message), label: "PROFILE"),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                    ProfileLocation()
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
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
    if (state.pathParameters
        .containsKey(RouteInformation[Routes.article_detail])) {
      pages.add(
        new BeamPage(
          key: ValueKey(RouteInformation[Routes.article_detail]),
          title: 'Article Detail',
          child: ArticleDetailScreen(),
        ),
      );
    }
    return pages;
  }

  @override
  List get pathBlueprints => [
        '/${RouteInformation[Routes.top_headline]}',
        '/${RouteInformation[Routes.top_headline]}/:${RouteInformation[Routes.article_detail]}'
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
    if (state.pathParameters
        .containsKey(RouteInformation[Routes.article_detail])) {
      pages.add(
        new BeamPage(
          key: ValueKey(RouteInformation[Routes.article_detail]),
          title: 'Article Detail',
          child: ArticleDetailScreen(),
        ),
      );
    }
    return pages;
  }

  @override
  List get pathBlueprints => [
        '/${RouteInformation[Routes.preferences]}',
        '/${RouteInformation[Routes.preferences]}/:${RouteInformation[Routes.article_detail]}'
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

final Map<Routes, String> RouteInformation = {
  Routes.top_headline: 'headline',
  Routes.preferences: 'preferences',
  Routes.profile: 'profile',
  Routes.article_detail: 'articleID'
};

enum Routes { top_headline, preferences, profile, article_detail }
