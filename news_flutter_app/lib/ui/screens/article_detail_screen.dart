import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArticleDetailView();
  }
}

class ArticleDetailView extends StatelessWidget {
  const ArticleDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Article Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [Text('Article Detail screen')],
        ),
      ),
    );
  }
}
