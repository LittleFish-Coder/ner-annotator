import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsProvider extends StateNotifier<List<TextSpan>> {
  final List<TextSpan> newsContent;
  NewsProvider(this.newsContent) : super(newsContent);

  void highlight(TextSelection position, String currHighlight, Color color) {
    int length = 0;
    int recordIndex = 0;
    List<String> splitText = [];
    bool flag = false;
    for (int index = 0; index < state.length; index++) {
      length += state[index].text!.length;
      if (length > position.start && length >= position.end) {
        recordIndex = index;
        splitText = state[index].text!.split(currHighlight);
        if (splitText.length == 2) {
          flag = true;
        }
        break;
      }
    }

    if (flag) {
      state.removeAt(recordIndex);
      state.insert(recordIndex, TextSpan(text: splitText[1]));
      state.insert(recordIndex, TextSpan(text: currHighlight, style: TextStyle(backgroundColor: color)));
      state.insert(recordIndex, TextSpan(text: splitText[0]));
    }

    state = [...state];
  }
}
