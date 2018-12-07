import 'package:flutter/material.dart';
import 'package:katv_app/models/song.model.dart';
import './app_inherited.widget.dart';

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

  /// ****** VIEW METHODS *******

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
