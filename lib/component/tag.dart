import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ner_annotator/page/home_page.dart';

import '../model/label.dart';

StateProvider<bool> isSelectedProvider = StateProvider<bool>((ref) => false);

class Tag extends ConsumerWidget {
  final String tagName;
  final Color color;
  final int index;
  const Tag({super.key, required this.tagName, required this.color, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tag = ref.watch(tagsProvider);
    bool isSelected = tag[index]!.selected;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          ref.read(tagsProvider.notifier).onSelected(index);
          // ref.read(selectedProvider.notifier).state = !ref.read(selectedProvider.notifier).state;
        },
        child: Container(
          width: 100,
          color: isSelected ? color.withOpacity(0.5) : Colors.grey.shade200,
          child: Row(
            children: [
              Container(width: 30, height: 30, color: color, child: isSelected ? const Icon(Icons.check) : const Icon(null)),
              Text(tagName),
            ],
          ),
        ),
      ),
    );
  }
}
