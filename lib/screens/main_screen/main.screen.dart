import 'package:flutter/material.dart';
import './widgets/video_component.widget.dart';
import './widgets/app_inherited.widget.dart';
import './widgets/ktv_ui.widget.dart';
import 'package:katv_app/models/category.model.dart';
import 'package:katv_app/data/songs_parser.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return AppInheritedWidget(
        child: Scaffold(
            appBar: AppBar(
              title: Text("My KaTV App"),
            ),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: VideoComponent(), flex: 2),
                Expanded(
                    child: FutureBuilder<List<Category>>(
                        future: loadSongs(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return KtvUI(
                              songData: snapshot.data,
                            );
                          }

                          return Center(child: Text("Loading songs..."));
                        }),
                    flex: 3),
              ],
            ))));
  }
}
