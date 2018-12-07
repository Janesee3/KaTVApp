import 'package:flutter/cupertino.dart';
import './select_song.widget.dart';
import './playlist.widget.dart';

class KtvUI extends StatefulWidget {
  KtvUI({Key key}) : super(key: key);

  @override
  _KtvUIState createState() => _KtvUIState();
}

class _KtvUIState extends State<KtvUI> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.music_note),
          title: Text('Select Songs'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.play_arrow),
          title: Text('Playlist'),
        ),
      ]),
      tabBuilder: (context, index) => CupertinoPageScaffold(
            child: Center(child: index == 0 ? SelectSong() : Playlist()),
          ),
    );
  }
}
