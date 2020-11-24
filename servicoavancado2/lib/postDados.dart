class PostDados {
  int _id;
  String _lat;
  String _lgt;
  String _img_64;

// contrutor

  PostDados(this._id, this._lat, this._lgt, this._img_64);

  String get img_64 => _img_64;
  set img_64(String value) {
    _img_64 = value;
  }
  String get lat => _lat;
  set lat(String value) {
    _lat = value;
  }
  String get lgt => _lgt;
  set lgt(String value) {
    _lgt = value;
  }
  int get id => _id;
  set id(int value) {
    _id = value;
  }
  

}
