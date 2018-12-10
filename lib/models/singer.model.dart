import './song.model.dart';

class Singer {
  String _name;
  List<Song> _songs;

  Singer(this._name, this._songs);

  String get name => _name;
  List<Song> get songs => _songs;
}
