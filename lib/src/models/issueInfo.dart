class IssueInfo {
  String description;
  String descriptionShort;
  String medicalCondition;
  String name;
  String possibleSymptoms;
  String profName;
  String synonyms;
  String treatment;

  IssueInfo(
    String description,
    String descriptionShort,
    String medicalCondition,
    String name,
    String possibleSymptoms,
    String profName,
    String synonyms,
    String treatment,
  ) {
    this.description = description;
    this.descriptionShort = descriptionShort;
    this.medicalCondition = medicalCondition;
    this.name = name;
    this.possibleSymptoms = possibleSymptoms;
    this.profName = profName;
    this.synonyms = synonyms;
    this.treatment = treatment;
  }

  IssueInfo.fromJson(Map<String, dynamic> json)
      : description = json['Description'],
        descriptionShort = json['DescriptionShort'],
        medicalCondition = json['MedicalCondition'],
        name = json['Name'],
        possibleSymptoms = json['PossibleSymptoms'],
        profName = json['ProfName'],
        synonyms = json['Synonyms'],
        treatment = json['TreatmentDescription'];
}
