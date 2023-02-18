import 'package:flutter/material.dart';
import 'package:fluent_appbar/fluent_appbar.dart' show FluentAppBar;
import '/models/webtoon_model.dart';
import '/utils/webtoon_api_fetcher.dart' show apiFetcher;
import '/utils/webtoon_build_widget_by_future.dart' show buildWidgetByFuture;
import '/widgets/webtoon_detail.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final ScrollController scrollController = ScrollController();
  static final Future<List<WebtoonIndex>> webtoonIndexesFuture =
      apiFetcher.fetchList(path: "today", fromJson: WebtoonIndex.fromJson);

  Widget indexWidgetMaker(
      {List<WebtoonIndex>? data, required BuildContext context}) {
    if (data == null) {
      throw Exception("No data available");
    }
    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24 +
            AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: data.length,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 20),
      itemBuilder: (BuildContext context, int index) {
        return SingleToon(webtoonIndex: data[index]);
        // return Toon(webtoon: snapshot.data![index]);
      },
    );
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FluentAppBar(
            scrollController: scrollController,
            titleText: '오늘의 웹툰',
            titleColor: Theme.of(context).appBarTheme.titleTextStyle!.color!,
            appBarColor: Theme.of(context).scaffoldBackgroundColor,
            boxShadowColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          buildWidgetByFuture<List<WebtoonIndex>>(
            future: webtoonIndexesFuture,
            widgetMaker: indexWidgetMaker,
          ),
        ],
      ),
    );
  }
}

class SingleToon extends StatelessWidget {
  SingleToon({super.key, required this.webtoonIndex}) {
    toonThumb = ToonThumb(webtoonIndex: webtoonIndex);
  }
  final WebtoonIndex webtoonIndex;
  late final ToonThumb toonThumb;

  @override
  GestureDetector build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => ToonDetail(
              webtoonId: webtoonIndex.id,
              toonThumb: toonThumb,
            ),
          ),
        ),
      },
      child: Column(
        children: [
          toonThumb,
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              webtoonIndex.title,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ],
      ),
    );
  }
}

