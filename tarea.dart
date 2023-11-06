class Tarea{
  int idtarea;
  String idmateria;
  String entrega;
  String descripcion;

  Tarea({
    this.idtarea=-1,
    required this.idmateria,
    required this.entrega,
    required this.descripcion
  });

  Map<String,dynamic> toJSON() {
    return {
      'idtarea': idtarea,
      'idmateria': idmateria,
      'f_entrega': entrega,
      'descripcion': descripcion
    };
  }
}