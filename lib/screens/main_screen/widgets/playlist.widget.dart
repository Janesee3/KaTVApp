import 'package:flutter/material.dart';
import './app_inherited.widget.dart';

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
