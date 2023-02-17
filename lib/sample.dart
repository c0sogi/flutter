import 'package:flutter/material.dart';

class MyListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal and Vertical ListViews'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Text('Item $index'),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100,
                  color: Colors.red,
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Text('Item $index'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main(){

  runApp(MaterialApp(
    home: Scaffold(
      body: MyListViewScreen(),
    ),
  ),);
}