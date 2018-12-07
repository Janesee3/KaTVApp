import 'package:flutter/material.dart';
import './widgets/video_component.widget.dart';
import './widgets/app_inherited.widget.dart';
import './widgets/ktv_ui.widget.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return AppInheritedWidget(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: VideoComponent(), flex: 2),
                Expanded(child: KtvUI(), flex: 3)
              ],
            ))));
  }
}
