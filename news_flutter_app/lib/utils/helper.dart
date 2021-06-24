import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async {
  try {
    await launch(url);
  } catch (e) {
    print(e.toString());
  }
}

bool didScrollReachTheEnd(ScrollController scroller) {
  if (!scroller.hasClients)
    return false;
  final maxScroll = scroller.position.maxScrollExtent;
  final currentScroll = scroller.offset;
  return currentScroll >= (maxScroll * 0.9);
}