import 'package:cloud_firestore/cloud_firestore.dart';

class Cita {
  String pacienteUid;
  String pacientefullName;
  String correoPaciente;
  String hora;
  String medicoUid;
  String medicofullName;
  String medicoEspecialidad;
  String dia;
  String finalizada;

  Cita(
      String pacienteUid,
      String pacientefullName,
      String correoPaciente,
      String hora,
      String medicoUid,
      String medicofullName,
      String medicoEspecialidad,
      String dia,
      String finalizada) {
    this.pacienteUid = pacienteUid;
    this.pacientefullName = pacientefullName;
    this.correoPaciente = correoPaciente;
    this.hora = hora;
    this.medicoUid = medicoUid;
    this.medicofullName = medicofullName;
    this.medicoEspecialidad = medicoEspecialidad;
    this.dia = dia;
    this.finalizada = finalizada;
  }

  Cita.fromJson(Map<String, dynamic> json)
      : pacienteUid = json['pacienteUid '],
        pacientefullName = json['pacientefullName'],
        correoPaciente = json['correoPaciente'],
        hora = json['hora'],
        medicoUid = json['medicoUid'],
        medicofullName = json['medicofullName'],
        medicoEspecialidad = json['medicoEspecialidad'],
        dia = json['dia'],
        finalizada = json['finalizada'];
}
