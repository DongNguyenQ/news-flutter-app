import 'package:flutter/material.dart';

class TopHeadlineScreen extends StatelessWidget {
  const TopHeadlineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TopHeadlineView();
  }
}

class TopHeadlineView extends StatelessWidget {
  const TopHeadlineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Headline'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [Text('Top Headline screen')],
        ),
      ),
    );
  }
}
