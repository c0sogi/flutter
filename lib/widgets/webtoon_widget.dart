import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web/models/webtoon_model.dart';
import 'package:flutter_web/services/webtoon_service.dart';
import 'package:fluent_appbar/fluent_appbar.dart'; // fluent_appbar: ^2.0.0

ApiFetcher singletonApiFetcher = ApiFetcher(
  scheme: "https",
  host: "webtoon-crawler.nomadcoders.workers.dev",
);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final ScrollController scrollController = ScrollController();
  static final Future<List<WebtoonIndex>> webtoonIndexesFuture =
      singletonApiFetcher.fetchList(
          path: "today", fromJson: WebtoonIndex.fromJson);

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
              id: webtoonIndex.id,
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
  ToonDetail({super.key, required this.id, required this.toonThumb}) {
    webtoonDetailFuture = singletonApiFetcher.fetch<WebtoonDetail>(
        path: id, fromJson: WebtoonDetail.fromJson);
    webtoonEpisodesFuture = singletonApiFetcher.fetchList(
        path: "$id/episodes", fromJson: WebtoonEpisode.fromJson);
  }
  final String id;
  final ToonThumb toonThumb;
  late final Future<WebtoonDetail> webtoonDetailFuture;
  late final Future<List<WebtoonEpisode>> webtoonEpisodesFuture;

  Widget episodeWidgetMaker(
      {List<WebtoonEpisode>? data, required BuildContext context}) {
    if (data == null) {
      throw Exception("No data available");
    }
    return IntrinsicHeight(
      child: Column(
        children: [for (var episode in data) Text(episode.title.toString())],
      ),
    );
  }

  Widget detailWidgetMaker(
      {WebtoonDetail? data, required BuildContext context}) {
    if (data == null) {
      throw Exception("No data available");
    }
    List<Widget> items = [
      Text(
        data.about,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      Text(
        "${data.genre} / ${data.age}",
        style: Theme.of(context).textTheme.displaySmall,
      ),
      buildWidgetByFuture(
        future: webtoonEpisodesFuture,
        widgetMaker: episodeWidgetMaker,
      ),
    ];

    return Flexible(
      flex: 1,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: items[index],
          );
        },
      ),
    );
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2, child: toonThumb),
          buildWidgetByFuture(
            future: webtoonDetailFuture,
            widgetMaker: detailWidgetMaker,
          )
        ],
      ),
    );
  }
}

Widget viewLoading() {
  return const Center(
    child: SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(),
    ),
  );
}

Widget buildWidgetByFuture<T>(
    {required Future<T> future,
    required Widget Function({T? data, required BuildContext context})
        widgetMaker,
    BuildContext? context}) {
  return FutureBuilder<T>(
    future: future,
    builder: (BuildContext context, snapshot) {
      return snapshot.hasData
          ? widgetMaker(data: snapshot.data, context: context)
          : viewLoading();
    },
  );
}
