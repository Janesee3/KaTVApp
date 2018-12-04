import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My KTV App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'KaTV App'),
    );
  }
}

// Home Page
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: VideoComponent(videoUrl: "meow"), flex: 2),
            Expanded(child: KtvUI(), flex: 3)
          ],
        )));
  }
}

// Video
class VideoComponent extends StatefulWidget {
  VideoComponent({Key key, this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
        apiKey: "AIzaSyAXhqkYvm0nn82rGDePq1l_ttw_T5Im1p0",
        videoUrl: "https://www.youtube.com/watch?v=TmwgJ8I7QCI",
        autoPlay: true,
        fullScreen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("This is a placeholder for video"),
              RaisedButton(
                child: Text("Press here to play video"),
                onPressed: playYoutubeVideo,
              ),
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
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Select Songs'),
    Tab(text: 'My Playlist'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
        child: CupertinoTabScaffold(
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
    ));
  }
}

// Inherited Widget

class _MyInherited extends InheritedWidget {
  _MyInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final MyInheritedWidgetState data;

  @override
  bool updateShouldNotify(_MyInherited oldWidget) {
    return true;
  }
}

class MyInheritedWidget extends StatefulWidget {
  MyInheritedWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  MyInheritedWidgetState createState() => new MyInheritedWidgetState();

  static MyInheritedWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited)
        .data;
  }
}

class MyInheritedWidgetState extends State<MyInheritedWidget> {
  /// List of Items
  List<String> _items = <String>[];

  /// Getter (number of items)
  int get itemsCount => _items.length;

  List<String> get items => _items;

  /// Helper method to add an Item
  void addItem(String reference) {
    setState(() {
      _items.add(reference);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _MyInherited(
      data: this,
      child: widget.child,
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

  Widget _getSongsListView(MyInheritedWidgetState state) {
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
                        Text(state.items[position]),
                        IconButton(
                          icon: Icon(Icons.drag_handle),
                          onPressed: () {},
                        )
                      ],
                    ))));
      },
      itemCount: state.items.length,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

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
        "The Meowttens": {
          "Meowing Under the Moon": "www.google.com",
          "Purr and Fur": "www.google.com",
          "Santa Claws is Rolling to Town": ""
        }
      },
      "Chinese": {
        "GEM": {
          "光年之外": "https://www.youtube.com/watch?v=T4SimnaiktU",
          "那一夜": "https://www.youtube.com/watch?v=ugVNDvnDDpA",
          "倒数": "https://www.youtube.com/watch?v=ma7r2HGqwXs"
        },
        "Hebe Tien": {
          "你就不要想起我": "https://www.youtube.com/watch?v=GsKbnsUN2RE",
          "魔鬼中的天使": "https://www.youtube.com/watch?v=na_xv5iFt2Y",
          "寂寞寂寞就好": "https://www.youtube.com/watch?v=DyFIzKYQQYE"
        },
        "JJ Lin": {},
        "Kimberlyn Chen": {}
      },
      "Korean": {"Ailee": {}, "IU": {}},
      "English": {
        "Fall Out Boy": {},
        "Taylor Swift": {},
        "Maroon 5": {},
        "Adele": {}
      }
    }
  };

  AppBar _getAppBar(String title, bool hasBack) {
    return AppBar(
        title: Text(title, style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black87),
        leading: hasBack
            ? IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _currPageType.removeLast();
                  });
                })
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
    Map categoryMap = _songData["categories"][_currPageType[0]];
    List<dynamic> keys = categoryMap.keys.toList();

    return Scaffold(
        appBar: _getAppBar(_currPageType[0], true),
        body: _getGridView(keys, _goToSinger));
  }

  Scaffold _getSingerDetailView(MyInheritedWidgetState state) {
    Map singerMap = _songData["categories"][_currPageType[0]][_currPageType[1]];
    List<dynamic> keys = singerMap.keys.toList();

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
                            Text(keys[position]),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                state.addItem(keys[position]);
                              },
                            )
                          ],
                        ))));
          },
          itemCount: keys.length,
        )));
  }

  Scaffold _getNotFoundView() {
    return Scaffold(
      appBar: _getAppBar("No Such Route", false),
      body: Center(child: Text(":(")),
    );
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
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    if (_currPageType.length == 0) return _getCategoriesView();
    if (_currPageType.length == 1) return _getCategoryDetailView();
    if (_currPageType.length == 2) return _getSingerDetailView(state);
    return _getNotFoundView();
  }
}
