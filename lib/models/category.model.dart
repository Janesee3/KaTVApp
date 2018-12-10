import './singer.model.dart';

class Category {
  String _name;
  List<Singer> _singers;

  Category(this._name, this._singers);

  String get name => _name;
  List<Singer> get singers => _singers;
}
