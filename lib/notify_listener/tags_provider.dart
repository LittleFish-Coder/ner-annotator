import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ner_annotator/model/label.dart';
import 'package:ner_annotator/page/home_page.dart';

class TagsProvider extends StateNotifier<List<Label?>> {
  final Ref ref;
  TagsProvider(this.ref) : super(fakeLabels);

  void onSelected(int index) {
    if (state[index]!.selected == true) {
      state[index]!.selected = !state[index]!.selected;
      ref.read(currTagProvider.notifier).state = null;
    } else {
      for (var element in state) {
        element!.selected = false;
      }
      state[index]!.selected = !state[index]!.selected;
    }
    state = [...state];
  }
}

List<Label> fakeLabels = [
  Label(false, "label 1", Colors.red),
  Label(false, "label 2", Colors.orange),
  Label(false, "label 3", Colors.yellow),
  Label(false, "label 4", Colors.green),
  Label(false, "label 5", Colors.blue),
  Label(false, "label 6", Colors.blueAccent),
  Label(false, "label 7", Colors.purple),
];
