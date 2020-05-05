import 'dart:convert';

class Infectado {
  String id;
  String fechaNotf;
  String codigoDivi;
  String ciudadUbi;
  String departamanto;
  String atencion;
  String edad;
  String sexo;
  String tipo;
  String estado;
  String paisProce;
  String fis;
  String fechaMuer;
  String fechaDiag;
  String fechaRec;
  String fecgaRepWeb;
  Infectado(
    this.id,
    this.fechaNotf,
    this.codigoDivi,
    this.ciudadUbi,
    this.departamanto,
    this.atencion,
    this.edad,
    this.sexo,
    this.tipo,
    this.estado,
    this.paisProce,
    this.fis,
    this.fechaMuer,
    this.fechaDiag,
    this.fechaRec,
    this.fecgaRepWeb,
  );

  Infectado.fromJson(Map<String, dynamic> json)
      : id = json['id_de_caso'],
        fechaNotf = json['fecha_de_notificaci_n'],
        codigoDivi = json['codigo_divipola'],
        ciudadUbi = json['ciudad_de_ubicaci_n'],
        departamanto = json['departamento'],
        atencion = json['atenci_n'],
        edad = json['edad'],
        sexo = json['sexo'],
        tipo = json['tipo'],
        estado = json['estado'],
        paisProce = json['pa_s_de_procedencia'],
        fis = json['fis'],
        fechaMuer = json['fecha_de_muerte'],
        fechaDiag = json['fecha_diagnostico'],
        fechaRec = json['fecha_recuperado'],
        fecgaRepWeb = json['fecha_reporte_web'];
}
