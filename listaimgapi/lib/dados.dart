class DadosDS403 {
  int _id;
  String _descricao;
  String _foto;

  DadosDS403(this._id, this._descricao, this._foto);

  // criar os get e set
  int get id => _id;
  set id(int value) {
    _id = value;
  }

  
  String get descricao => _descricao;
  set descricao(String value) {
    _descricao = value;
  }

  String get foto => _foto;
  set foto(String value) {
    _foto = value;
  }
}
