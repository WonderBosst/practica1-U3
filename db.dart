import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dam_u3_practica1/materia.dart';
import 'package:dam_u3_practica1/tarea.dart';

class DB{
  static Future<Database> _abrirDB() async{
    return openDatabase(
        join(await getDatabasesPath(), "practU3.db"),
        onCreate: (db,version){
          return db.transaction((txn) async {
            // Crear la tabla MATERIA
            await txn.execute(
              "CREATE TABLE MATERIA("
                  "IDMATERIA TEXT PRIMARY KEY, "
                  "NOMBRE TEXT, "
                  "SEMESTRE TEXT,"
                  "DOCENTE TEXT)",
            );

            // Crear la tabla TAREA con la clave foránea
            await txn.execute(
              "CREATE TABLE TAREA("
                  "IDTAREA INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "IDMATERIA TEXT, "
                  "F_ENTREGA TEXT, "
                  "DESCRIPCION TEXT,"
                  "FOREIGN KEY (IDMATERIA) REFERENCES MATERIA(IDMATERIA))",
            );
          });
        },
        version: 1
    );
  }

  //CRUD PARA LA TABLA MATERIAS
  static Future<int> insertar(Materia e) async{
    Database db= await _abrirDB();
    return db.insert("MATERIA", e.toJSON(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Materia>> mostrarTodos() async{
    Database db=await _abrirDB();
    List<Map<String,dynamic>> resultado=await db.query("MATERIA");
    return List.generate(resultado.length , (index){
      return Materia(
          idmateria: resultado[index]['IDMATERIA'],
          nombre: resultado[index]['NOMBRE'],
          semestre: resultado[index]['SEMESTRE'],
          docente: resultado[index]['DOCENTE']
      );
    });
  }

  static Future<int> actualizar(Materia e) async{
    Database db=await _abrirDB();
    return db.update("MATERIA", e.toJSON(),where: "IDMATERIA=?",whereArgs: [e.idmateria]);
  }

  static Future<int> eliminar(String idmateria) async{
    Database db=await _abrirDB();
    return db.delete("MATERIA",where: "IDMATERIA=?",whereArgs: [idmateria]);
  }
  //-------------------------------------------------------------------

  //CRUD PARA LA TABLA TAREAS
  static Future<int> insertarT(Tarea e) async{
    Database db= await _abrirDB();
    return db.insert("TAREA", {'IDMATERIA':e.idmateria,'F_ENTREGA':e.entrega,'DESCRIPCION':e.descripcion});
  }

  static Future<List<Tarea>> mostrarTodasTareas() async{
    Database db=await _abrirDB();
    final DateTime now=DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;
    final int currentDay=now.day;
    final String formattedCurrentDate = '$currentYear/${currentMonth.toString().padLeft(2, '0')}/${currentDay.toString().padLeft(2, '0')}';

    List<Map<String,dynamic>> resultado=await db.query("TAREA",where: "F_ENTREGA LIKE ?",
      whereArgs: ['$formattedCurrentDate%'], orderBy: 'F_ENTREGA ASC',);
    return List.generate(resultado.length , (index){
      return Tarea(
          idtarea: resultado[index]['IDTAREA'],
          idmateria: resultado[index]['IDMATERIA'],
          entrega: resultado[index]['F_ENTREGA'],
          descripcion: resultado[index]['DESCRIPCION']
      );
    });
  }

  static Future<List<Tarea>> mostrarTareasPosteriores() async{
    Database db=await _abrirDB();
    final DateTime now=DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;
    final int currentDay = now.day;
    final String formattedCurrentDate = '$currentYear/${currentMonth.toString().padLeft(2, '0')}/${currentDay.toString().padLeft(2, '0')}';

    List<Map<String,dynamic>> resultado=await db.query("TAREA",where: "F_ENTREGA NOT LIKE ?",
      whereArgs: ['$formattedCurrentDate%'], orderBy: 'F_ENTREGA ASC',);
    return List.generate(resultado.length , (index){
      return Tarea(
          idtarea: resultado[index]['IDTAREA'],
          idmateria: resultado[index]['IDMATERIA'],
          entrega: resultado[index]['F_ENTREGA'],
          descripcion: resultado[index]['DESCRIPCION']
      );
    });
  }

  static Future<int> actualizarT(Tarea e) async{
    Database db=await _abrirDB();
    return db.update("TAREA", e.toJSON(),where: "IDTAREA=?",whereArgs: [e.idtarea]);
  }

  static Future<int> eliminarT(int idtarea) async{
    Database db=await _abrirDB();
    return db.delete("TAREA",where: "IDTAREA=?",whereArgs: [idtarea]);
  }
}