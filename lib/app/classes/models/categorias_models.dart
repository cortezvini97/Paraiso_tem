class CategoriasModel
{
  String _id;
  String _categoria;
  // ignore: non_constant_identifier_names
  String _icone_categoria;

  CategoriasModel(this._id, this._categoria, this._icone_categoria);

  // ignore: non_constant_identifier_names, unnecessary_getters_setters
  String get icone_categoria => _icone_categoria;


  // ignore: unnecessary_getters_setters, non_constant_identifier_names
  set icone_categoria(String value) {
    _icone_categoria = value;
  }

  // ignore: unnecessary_getters_setters
  String get categoria => _categoria;

  // ignore: unnecessary_getters_setters
  set categoria(String value) {
    _categoria = value;
  }

  // ignore: unnecessary_getters_setters
  String get id => _id;

  // ignore: unnecessary_getters_setters
  set id(String value) {
    _id = value;
  }
}