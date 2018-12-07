import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:katv_app/models/song.model.dart';

// Home Page
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

// Inherited Widget for Video and KTV

class _InheritedWidgetForApp extends InheritedWidget {
  _InheritedWidgetForApp({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final AppInheritedWidgetState data;

  @override
  bool updateShouldNotify(_InheritedWidgetForApp oldWidget) {
    return true;
  }
}

class AppInheritedWidget extends StatefulWidget {
  AppInheritedWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  AppInheritedWidgetState createState() => new AppInheritedWidgetState();

  static AppInheritedWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedWidgetForApp)
            as _InheritedWidgetForApp)
        .data;
  }
}

class AppInheritedWidgetState extends State<AppInheritedWidget> {
  List<Song> _songs = <Song>[];

  List<Song> get songs => _songs;

  void addSong(Song reference, BuildContext context) {
    setState(() {
      _songs.add(reference);
    });

    final snackBar = SnackBar(
      content: Text('Added ' + reference.name),
      duration: Duration(seconds: 1),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void removeFirstSong() {
    setState(() {
      if (_songs.length > 0) _songs.removeAt(0);
    });
  }

  void pushSongToTop(Song song, int songIndex) {
    setState(() {
      _songs.removeAt(songIndex);
      _songs.insert(0, song);
    });
  }

  void removeSong(int songIndex) {
    setState(() {
      _songs.removeAt(songIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedWidgetForApp(
      data: this,
      child: widget.child,
    );
  }
}

// Video
class VideoComponent extends StatefulWidget {
  VideoComponent({Key key}) : super(key: key);

  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  void playYoutubeVideo(AppInheritedWidgetState state) {
    if (state._songs.length <= 0) {
      // hello
    } else {
      FlutterYoutube.playYoutubeVideoByUrl(
          apiKey: "AIzaSyAXhqkYvm0nn82rGDePq1l_ttw_T5Im1p0",
          videoUrl: state._songs[0].url,
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
              state._songs.length == 0
                  ? Text("Nothing on playlist now!")
                  : Text("Now playing " + state._songs[0].name),
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

// KtvUI

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

// Playlist Tab

class Playlist extends StatefulWidget {
  Playlist({Key key}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  AppBar _getAppBar(String title) {
    return AppBar(
        title: Text(title, style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black87));
  }

  Widget _getSongsListView(AppInheritedWidgetState state) {
    return Center(
        child: ListView.builder(
      itemBuilder: (context, position) {
        return GestureDetector(
            onTap: () {},
            child: Card(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 12.0, 12.0, 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(state.songs[position].name),
                        Container(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_upward),
                                onPressed: () => state.pushSongToTop(
                                    state.songs[position], position),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => state.removeSong(position),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))));
      },
      itemCount: state.songs.length,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final AppInheritedWidgetState state = AppInheritedWidget.of(context);

    return Scaffold(
      appBar: _getAppBar("Playlist"),
      body: _getSongsListView(state),
    );
  }
}

// Select Songs Tab
class SelectSong extends StatefulWidget {
  SelectSong({Key key, this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  _SelectSongState createState() => _SelectSongState();
}

class _SelectSongState extends State<SelectSong> {
  final List<String> _currPageType = new List<String>();
  final Map _songData = {
    "categories": {
      "Meow Language": {
        "The Meowttens": [
          Song("Meowing Under the Moon", "www.google.com"),
          Song("Purr and Fur", "www.google.com"),
          Song("Santa Claws is Rolling to Town", "")
        ]
      },
      "Chinese": {
        "GEM": [
          Song("光年之外", "https://www.youtube.com/watch?v=T4SimnaiktU"),
          Song("那一夜", "https://www.youtube.com/watch?v=ugVNDvnDDpA"),
          Song("倒数", "https://www.youtube.com/watch?v=ma7r2HGqwXs")
        ],
        "Hebe Tien": [
          Song("你就不要想起我", "https://www.youtube.com/watch?v=GsKbnsUN2RE"),
          Song("魔鬼中的天使", "https://www.youtube.com/watch?v=na_xv5iFt2Y"),
          Song("寂寞寂寞就好", "https://www.youtube.com/watch?v=DyFIzKYQQYE")
        ],
        "JJ Lin": [
          Song("曹操", "https://www.youtube.com/watch?v=3J_bkgexrE8"),
          Song("不死之身", "https://www.youtube.com/watch?v=h03_hs_QbEE"),
          Song("美人鱼", "https://www.youtube.com/watch?v=jdf3gxFP0F8"),
          Song("就是我", "https://www.youtube.com/watch?v=GLtLjBS0cs0")
        ],
        "Kimberlyn Chen": [
          Song("爱你", "https://www.youtube.com/watch?v=4QoVMJN-nFs")
        ]
      },
      "Korean": {
        "Ailee": [
          Song("Reminiscing", "https://www.youtube.com/watch?v=Spo8fiFHQls"),
          Song("Heaven", "https://www.youtube.com/watch?v=DQzK8II1qAU"),
          Song("I will go to you like first snow",
              "https://www.youtube.com/watch?v=xW7gKmeXhuQ"),
          Song(
              "I will show you", "https://www.youtube.com/watch?v=-Q-OmGsk4hM"),
          Song("If you", "https://www.youtube.com/watch?v=R3xy0vbxNUs"),
          Song("Rainy Day", "https://www.youtube.com/watch?v=qSFFDxKE4B4"),
          Song("U&I", "https://www.youtube.com/watch?v=398DDVagbPI"),
        ]
      },
      "English": {
        "Fall Out Boy": [
          Song("Dance, Dance", "https://www.youtube.com/watch?v=bxxJ25-3QEA"),
          Song("Sugar, we're going down",
              "https://www.youtube.com/watch?v=d5lOB7Ibjhg"),
        ],
        "Taylor Swift": [
          Song("Love Story", "https://www.youtube.com/watch?v=PDM-GcQ6NT0")
        ],
        "Maroon 5": [
          Song("Animals", "https://www.youtube.com/watch?v=a5-tjIB9YBk"),
          Song("She will be loved",
              "https://www.youtube.com/watch?v=zJmVq8-p1CE"),
        ],
        "Adele": [
          Song("Someone like you",
              "https://www.youtube.com/watch?v=Cgdes6lFjzM"),
          Song("All I Asked", "https://www.youtube.com/watch?v=QnChoAPlMyc"),
          Song("When we were young",
              "https://www.youtube.com/watch?v=vVGUM_e5zDA"),
        ]
      }
    }
  };

  /// **** VIEW METHODS *******

  AppBar _getAppBar(String title, bool hasBack) {
    return AppBar(
        title: Text(title, style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black87),
        leading: hasBack
            ? IconButton(icon: Icon(Icons.chevron_left), onPressed: _goBack)
            : null);
  }

  Widget _getGridView(List<dynamic> items, Function onTap) {
    return Center(
        child: GridView.builder(
      itemBuilder: (context, position) {
        return GestureDetector(
            onTap: () => onTap(items[position]),
            child: Card(
              child: Center(child: Text(items[position])),
            ));
      },
      itemCount: items.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    ));
  }

  Scaffold _getCategoriesView() {
    Map categoriesMap = _songData["categories"];
    List<dynamic> keys = categoriesMap.keys.toList();

    return Scaffold(
        appBar: _getAppBar("Select Songs", false),
        body: _getGridView(keys, _goToCategory));
  }

  Scaffold _getCategoryDetailView() {
    Map categoryMap =
        _songData["categories"][_currPageType[0]]; // eg. GEM, JJ ...
    List<dynamic> keys = categoryMap.keys.toList();

    return Scaffold(
        appBar: _getAppBar(_currPageType[0], true),
        body: _getGridView(keys, _goToSinger));
  }

  Scaffold _getSingerDetailView(AppInheritedWidgetState appState) {
    List<Song> songs =
        _songData["categories"][_currPageType[0]][_currPageType[1]];

    return Scaffold(
        appBar: _getAppBar(_currPageType[1], true),
        body: Center(
            child: ListView.builder(
          itemBuilder: (context, position) {
            return GestureDetector(
                onTap: () {},
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(24.0, 12.0, 12.0, 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(songs[position].name),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                appState.addSong(songs[position], context);
                              },
                            )
                          ],
                        ))));
          },
          itemCount: songs.length,
        )));
  }

  Scaffold _getNotFoundView() {
    return Scaffold(
      appBar: _getAppBar("No Such Route", false),
      body: Center(child: Text(":(")),
    );
  }

  /// **** TAP CALLBACKS *******

  void _goBack() {
    setState(() {
      _currPageType.removeLast();
    });
  }

  void _goToCategory(String category) {
    setState(() {
      _currPageType.add(category);
    });
  }

  void _goToSinger(String singer) {
    setState(() {
      _currPageType.add(singer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppInheritedWidgetState appState = AppInheritedWidget.of(context);
    if (_currPageType.length == 0) return _getCategoriesView();
    if (_currPageType.length == 1) return _getCategoryDetailView();
    if (_currPageType.length == 2) return _getSingerDetailView(appState);
    return _getNotFoundView();
  }
}
