import 'package:flutter/material.dart';
import './app_inherited.widget.dart';
import 'package:katv_app/models/category.model.dart';
import 'package:katv_app/models/singer.model.dart';
import 'package:katv_app/models/song.model.dart';

class SelectSong extends StatefulWidget {
  SelectSong({Key key, this.songData}) : super(key: key);

  final List<Category> songData;

  @override
  _SelectSongState createState() => _SelectSongState();
}

class _SelectSongState extends State<SelectSong> {
  final List<String> _currPageType = new List<String>();

  Category _getSelectedCategory() {
    if (_currPageType.length > 0) {
      return widget.songData
          .where((cat) => cat.name == _currPageType[0])
          .toList()[0];
    }
  }

  Singer _getSelectedSinger() {
    if (_currPageType.length > 1) {
      return _getSelectedCategory()
          .singers
          .where((singer) => singer.name == _currPageType[1])
          .toList()[0];
    }
  }

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
    List cats = widget.songData.map((cat) => cat.name).toList();

    return Scaffold(
        appBar: _getAppBar("Select Songs", false),
        body: _getGridView(cats, _goToCategory));
  }

  Scaffold _getCategoryDetailView() {
    List singers =
        _getSelectedCategory().singers.map((singer) => singer.name).toList();

    return Scaffold(
        appBar: _getAppBar(_currPageType[0], true),
        body: _getGridView(singers, _goToSinger));
  }

  Scaffold _getSingerDetailView(AppInheritedWidgetState appState) {
    List<Song> songs = _getSelectedSinger().songs;

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
