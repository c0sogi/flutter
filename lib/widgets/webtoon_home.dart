import 'package:flutter/material.dart';
import 'package:fluent_appbar/fluent_appbar.dart' show FluentAppBar;
import '/models/webtoon_model.dart';
import '/utils/webtoon_api_fetcher.dart' show apiFetcher;
import '/utils/webtoon_build_widget_by_future.dart' show buildWidgetByFuture;
import 'webtoon_webview.dart' show MyWebView;

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

class ToonThumb extends StatelessWidget {
  ToonThumb({super.key, required this.webtoonIndex})
      : thumb = Image.network(webtoonIndex.thumb, fit: BoxFit.cover);
  final WebtoonIndex webtoonIndex;
  final Image thumb;

  @override
  Hero build(BuildContext context) {
    return Hero(
      tag: webtoonIndex.id,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.6,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Color.fromARGB(128, 0, 0, 0),
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: thumb,
      ),
    );
  }
}

class ToonDetail extends StatelessWidget {
  ToonDetail({super.key, required this.webtoonId, required this.toonThumb}) {
    webtoonDetailFuture = apiFetcher.fetch<WebtoonDetail>(
        path: webtoonId, fromJson: WebtoonDetail.fromJson);
    webtoonEpisodesFuture = apiFetcher.fetchList(
        path: "$webtoonId/episodes", fromJson: WebtoonEpisode.fromJson);
  }
  final String webtoonId;
  final ToonThumb toonThumb;
  late final Future<WebtoonDetail> webtoonDetailFuture;
  late final Future<List<WebtoonEpisode>> webtoonEpisodesFuture;

  Widget detailWidgetMaker(
      {WebtoonDetail? data, required BuildContext context}) {
    if (data == null) {
      throw Exception("No data available");
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Text(
                data.about,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "${data.genre} / ${data.age}",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
        buildWidgetByFuture(
          future: webtoonEpisodesFuture,
          widgetMaker: episodeWidgetMaker,
        ),
      ],
    );
  }

  Widget episodeWidgetMaker(
      {List<WebtoonEpisode>? data, required BuildContext context}) {
    if (data == null) {
      throw Exception("No data available");
    }
    return Column(
      children: [
        for (var episode in data)
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => MyWebView(
                    url:
                        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}",
                  ),
                ),
              ),
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 2,
              ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 5,
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1))
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Theme.of(context).cardTheme.color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    episode.title.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.background,
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: toonThumb,
            ),
            buildWidgetByFuture(
              future: webtoonDetailFuture,
              widgetMaker: detailWidgetMaker,
            )
          ],
        ),
      ),
    );
  }
}
