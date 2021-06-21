import 'package:flutter/material.dart';

class BaseContainerView extends StatefulWidget {
  const BaseContainerView({Key? key}) : super(key: key);

  @override
  _BaseContainerViewState createState() => _BaseContainerViewState();
}

class _BaseContainerViewState extends State<BaseContainerView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _onPressed(value);
        },
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person))
        ],
      ),
    );
  }

  void _onPressed(int index) {
    print('CURRENT INDEX : $_currentIndex');
    setState(() => _currentIndex = index);
  }
}
