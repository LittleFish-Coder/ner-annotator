import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ner_annotator/component/tag.dart';
import 'package:ner_annotator/model/label.dart';
import 'package:ner_annotator/notify_listener/news_provider.dart';
import 'package:ner_annotator/notify_listener/tags_provider.dart';

final StateProvider<Tag?> currTagProvider = StateProvider((ref) => null);

final tagsProvider = StateNotifierProvider<TagsProvider, List<Label?>>((ref) {
  return TagsProvider(ref);
});

final StateProvider<String> currHighlightProvider =
    StateProvider<String>((ref) => "");

final StateProvider<TextSelection?> positionProvider =
    StateProvider<TextSelection?>((ref) => null);

final StateNotifierProvider<NewsProvider, List<TextSpan>> newsProvider =
    StateNotifierProvider((ref) {
  return NewsProvider([const TextSpan(text: fakeNews)]);
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("NCKU NER Annotator")),
      body: Column(
        children: const <Widget>[
          Header(),
          Divider(),
          Expanded(child: TextBody()),
        ],
      ),
      bottomNavigationBar: footer(),
    );
  }
}

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagList = ref.watch(tagsProvider);
    return Wrap(
      children: [
        for (int index = 0; index < tagList.length; index++)
          Tag(
            tagName: tagList[index]!.labelName,
            color: tagList[index]!.color,
            index: index,
          ),
      ],
    );
  }
}

class TextBody extends ConsumerWidget {
  const TextBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currTag = ref.watch(currTagProvider);
    final currHighlight = ref.watch(currHighlightProvider);
    final position = ref.watch(positionProvider);
    final newsContent = ref.watch(newsProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Listener(
            onPointerDown: (event) {
              debugPrint("down");
            },
            onPointerUp: ((event) {
              if (currTag != null) {
                ref.read(newsProvider.notifier).highlight(position!, currHighlight, currTag.color);
                ref.read(currHighlightProvider.notifier).state = "";
              }
              debugPrint("up");
            }),
            child: SelectableText.rich(
              TextSpan(
                children: [
                  for (TextSpan textSpan in newsContent) textSpan,
                ],
              ),
              onSelectionChanged:
                  (TextSelection selection, SelectionChangedCause? cause) {
                if (cause == SelectionChangedCause.drag) {
                  ref.read(positionProvider.notifier).state = selection;
                  final subString =
                      fakeNews.substring(selection.start, selection.end);
                  ref.read(currHighlightProvider.notifier).state = subString;
                  debugPrint("currHighlight: $currHighlight");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget footer() {
  return Container(
    padding: const EdgeInsets.all(5),
    color: Colors.teal,
    child: const Align(
      alignment: Alignment.center,
      widthFactor: 1.0,
      heightFactor: 1.0,
      child:
          Text('This website is designed for NCKU Miin Wu School of Computing'),
    ),
  );
}

const String fakeNews =
    "歷經4天15輪投票，美國共和黨領袖麥卡錫（Kevin McCarthy）今天晚間終於擺平黨內極右翼勢力，以216票過半票數如願執起眾議院議長槌，讓這場164年以來拖延最久的議長選舉順利落幕。在歷經數天協商、一連串讓步後，麥卡錫今天晚間終於以216票跨越當選門檻，成為眾議院新一屆議長；民主黨非裔領袖傑福瑞斯（Hakeem Jeffries）則獲得212票。這是自1859年以來，耗費最多輪表決的眾院議長選舉；當年花費44次表決才選出議長。麥卡錫陣營與黨內極右翼勢力協商今天稍早取得重大進展，首兩輪表決翻轉15張反對票，離當選門檻僅差3票，黨內杯葛人數降至6人；眾議院下午至晚間休會期間，麥卡錫持續與反對派溝通，期間傳出進一步進展，麥卡錫晚間步入議場時一臉信心勝券在握。不過，第14輪表決時，僅蓋茨（Matt Gaetz）與波柏特（Lauren Boebert）2位反對派議員改投棄權票，導致麥卡錫僅得216票，以1票之差落敗；麥卡錫接著氣憤走向蓋茨，兩人展開激烈辯論，現場一度陷入混亂。麥卡錫陣營原先打算要求休會至美東時間9日中午，但表決到一半事情似乎出現轉圜，共和黨放棄休會策略，改進入第15輪投票。在新增4位反對派議員改投棄權票情況下，麥卡錫終於跨過當選門檻。在正常情況下，議長當選門檻為過半數眾院席次的218票，但可能隨現場缺席議員、投棄權票人數降低。在15輪表決有6票棄權下，當選門檻為215票。現年57歲的麥卡錫來自加州，擁有16年眾議員資歷。2007年進到國會後，短短兩年就晉身眾議院共和黨領導階層，一路從首席副黨鞭、黨鞭做到多數黨領袖，但眾院議長一職卻讓他等超過7年才等到。如今雖如願執議長槌，麥卡錫未來議長恐不好當。共和黨目前在眾議院占222席，僅多民主黨10席，即便議長選舉爭取到部分極右人士支持，在共和黨席次優勢不足下，麥卡錫未來勢必時常受到極右翼勢力牽制。此外，為換取支持，麥卡錫同意恢復過去只要一名眾議員就能提出「罷黜議長」（vacate the chair）動議的規定，等於讓極右翼拿槍指著他腦袋。有線電視新聞網（CNN）報導，麥卡錫其他的讓步包括讓更多極右翼「自由黨團」（Freedom Caucus）成員加入能主宰法案命運的程序委員會（Rules Committee）、確保議員至少有72小時檢閱法案、鬆綁院會修正案提出限制、恢復議員砍聯邦官員薪水權利等。隨著新議長麥卡錫出線，新一屆眾議員緊接著將宣誓就職，讓眾議院正式開始運作。新會期也象徵一個時代的結束，民主黨籍前眾議院議長裴洛西（Nancy Pelosi）是美國史上第一位女性議長、政治上第三號人物、也是任職時間最久的民主黨議長，之前宣布結束她擔任眾院議長的歷史性任期，不再競選民主黨領導權。在美國總統繼任順序中，眾議院議長是繼美國副總統兼參議院議長後的第二順位繼承人，也是美國政壇地位第三高的政治人物。";
