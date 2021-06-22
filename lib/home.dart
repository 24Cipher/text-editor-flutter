import 'package:flutter/material.dart';
import 'package:text_editor/editor.dart';

class Home extends StatefulWidget {
  final textData;
  const Home({Key key, this.textData = ''}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _navigate() =>
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => Editor()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _navigate, child: Text('Open editor!')),
              SizedBox(height: 10),
              Text('Data from editor : ${widget.textData}'),
            ],
          ),
        ));
  }
}
