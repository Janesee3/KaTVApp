import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:katv_app/models/category.model.dart';
import 'package:katv_app/models/singer.model.dart';
import 'package:katv_app/models/song.model.dart';

Future<String> _loadSongsAsset() async {
  return await rootBundle.loadString('assets/data/songs.json');
}

Future<List<Category>> loadSongs() async {
  String jsonSongs = await _loadSongsAsset();
  return _parseJsonSongData(jsonSongs);
}

List<Category> _parseJsonSongData(String jsonString) {
  Map decoded = jsonDecode(jsonString);
  List categoryList = decoded['categories'];

  List typeSafe = List<Category>();
  categoryList.forEach((category) => typeSafe.add(
      Category(category['name'], _parseJsonForSingers(category['singers']))));
  return typeSafe;
}

List<Song> _parseJsonForSongs(var songsList) {
  List typeSafe = List<Song>();
  songsList.forEach((song) => typeSafe.add(Song(song['name'], song['url'])));
  return typeSafe;
}

List<Singer> _parseJsonForSingers(var singersList) {
  List typeSafe = List<Singer>();
  singersList.forEach((singer) => typeSafe
      .add(Singer(singer["name"], _parseJsonForSongs(singer['songs']))));
  return typeSafe;
}
