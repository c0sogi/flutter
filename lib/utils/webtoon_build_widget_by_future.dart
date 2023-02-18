import 'package:flutter/material.dart';

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