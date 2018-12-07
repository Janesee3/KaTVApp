import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:katv_app/models/song.model.dart';

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