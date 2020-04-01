class Issue {
  int id;
  String name;
  String accuracy;
  String icd;
  String icdName;
  String profName;
  int ranking;

  Issue(int id, String name,String accuracy ,String icd, String icdName,
      String profName, int ranking) {
    this.id = id;
    this.name = name;
    this.accuracy = accuracy;
    this.icd = icd;
    this.icdName = icdName;
    this.profName = profName;
    this.ranking = ranking;
  }

  Issue.fromJson(Map<String,dynamic> json): 
    id = json['ID'],
    name = json['Name'],
    accuracy = json['Accuracy'].toString(),
    icd = json['Icd'],
    icdName = json['IcdName'],
    profName = json['ProfName'],
    ranking = json['Ranking'];
}
