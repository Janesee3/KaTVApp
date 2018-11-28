import 'package:flutter/material.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[VideoComponent(videoUrl: "meow"), KtvUI()],
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("This is a placeholder for video"),
          RaisedButton(
            child: Text("Press here to play video"),
            onPressed: playYoutubeVideo,
          ),
        ],
      ),
    );
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
    return Center(
        child: Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: myTabs,
          labelColor: Colors.black,
        ),
        SizedBox(
            height: 300.0,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                SelectSong(),
                Center(child: Text("Your Playlist"))
              ],
            ))
      ],
    ));
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
  AppBar _getAppBar(String title) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Colors.black87)),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black87),
    );
  }

  void _pushToCategory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // Returns a Scaffold. We are defining the body here

          return Scaffold(
              appBar: _getAppBar("Chinese Songs"),
              body: Center(
                child: RaisedButton(
                  child: Text("Meow"),
                  onPressed: () => _pushToCategory(context),
                ),
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar("Select Songs"),
        body: Center(
          child: RaisedButton(
            child: Text("Chinese Songs"),
            onPressed: () => _pushToCategory(context),
          ),
        ));
  }
}
