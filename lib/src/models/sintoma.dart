class Sintoma {
  String name;
  int id;

  Sintoma(String name, int id) {
    this.name = name;
    this.id = id;
  }

  Sintoma.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        name = json['Name'];

  int get sintomaId{
    return id;
  }
  String get sintomaName{
    return name;
  }
}
