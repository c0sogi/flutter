import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web/models/webtoon_model.dart';
import 'package:flutter_web/services/webtoon_service.dart';
import 'package:fluent_appbar/fluent_appbar.dart'; // fluent_appbar: ^2.0.0

WebtoonAPI singletonWebtoonAPI = WebtoonAPI(
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
  static final Future<List<WebtoonIndex>?> webtoonIndexesFuture =
      singletonWebtoonAPI.fetchList(
          path: "today", fromJson: WebtoonIndex.fromJson);

  Center viewLoading() {
    return const Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(),
      ),
    );
  }

  FutureBuilder<List<WebtoonIndex>?> buildFutureListView() {
    return FutureBuilder<List<WebtoonIndex>?>(
      future: webtoonIndexesFuture,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return viewLoading();
        } else {
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
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (BuildContext context, int index) {
              return SingleToon(webtoonIndex: snapshot.data![index]);
              // return Toon(webtoon: snapshot.data![index]);
            },
          );
        }
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
          buildFutureListView(),
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
    webtoonDetailFuture = singletonWebtoonAPI.fetch<WebtoonDetail>(
        path: id, fromJson: WebtoonDetail.fromJson);
  }
  final String id;
  final ToonThumb toonThumb;
  late final Future<WebtoonDetail> webtoonDetailFuture;

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          toonThumb,
        ],
      ),
    );
  }
}
