import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import './app_inherited.widget.dart';

class VideoComponent extends StatefulWidget {
  VideoComponent({Key key}) : super(key: key);

  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  void playYoutubeVideo(AppInheritedWidgetState state) {
    if (state.songs.length <= 0) {
      // hello
    } else {
      FlutterYoutube.playYoutubeVideoByUrl(
          apiKey: "AIzaSyAXhqkYvm0nn82rGDePq1l_ttw_T5Im1p0",
          videoUrl: state.songs[0].url,
          autoPlay: true,
          fullScreen: false);
    }
  }

  void _nextVideo(AppInheritedWidgetState appState) {
    appState.removeFirstSong();
  }

  @override
  Widget build(BuildContext context) {
    final AppInheritedWidgetState state = AppInheritedWidget.of(context);

    return Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              state.songs.length == 0
                  ? Text("Nothing on playlist now!")
                  : Text("Now playing " + state.songs[0].name),
              RaisedButton.icon(
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: () => playYoutubeVideo(state),
                  label: Text("Play Video")),
              RaisedButton.icon(
                  icon: Icon(Icons.queue_play_next),
                  onPressed: () => _nextVideo(state),
                  label: Text("Next Song"))
            ],
          ),
        ));
  }
}
