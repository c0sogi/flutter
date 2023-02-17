import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 30,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          color: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Row(
              children: const [
                Text("금호동3가"),
                Icon(Icons.expand_more),
              ],
            ),
            actions: const [
              SizedBox(width: 20),
              Icon(Icons.search),
              SizedBox(width: 20),
              Icon(Icons.menu),
              SizedBox(width: 20),
              Icon(Icons.notifications),
            ],
          ),
        ),
        body: Container(
          height: 125,
          margin: const EdgeInsets.all(5),
          child: Row(
            children: [
              SizedBox(
                width: 125,
                height: 125,
                child: Image.asset("images/site_logo.png", fit: BoxFit.cover),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "[급처] 캐논 DSLR 100D (단렌즈, 충전기 16기가SD 포함)",
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "성동구 행당동 · 끌올 10분 전",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "210,000원",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.favorite_border),
                          const SizedBox(width: 5),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: const Text(
                              "4",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
