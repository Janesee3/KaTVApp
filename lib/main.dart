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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final bool _isSongSelection = true;
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            VideoComponent(videoUrl: "meow"),
            TabBar(
              controller: _tabController,
              tabs: myTabs,
              labelColor: Colors.black,
            ),
            SizedBox(
                height: 300.0,
                child: TabBarView(
                  controller: _tabController,
                  children: myTabs.map((Tab tab) {
                    return Center(child: Text(tab.text));
                  }).toList(),
                ))
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
        apiKey: "AIzaSyA-r5-33ElkuO2nkRSfQ1DFr_e1M0c9kzU",
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

// Tabbed
