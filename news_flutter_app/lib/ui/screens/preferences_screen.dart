import 'package:flutter/material.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferencesView();
  }
}

class PreferencesView extends StatelessWidget {
  const PreferencesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Preferences'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [Text('Preferences screen')],
        ),
      ),
    );
  }
}
