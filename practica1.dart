import 'package:flutter/material.dart';
import 'materia.dart';
import 'db.dart';
import 'tarea.dart';

class P31 extends StatefulWidget {
  const P31({super.key});

  @override
  State<P31> createState() => _P31State();
}

class _P31State extends State<P31> {
  int _index=1;
  String titulo="📓 Administrar materias";
  //Controladores de Materia
  final idmateria=TextEditingController();
  final nombreM=TextEditingController();
  final semestre=TextEditingController();
  final docente=TextEditingController();
  //Controladores de Tarea
  final idtarea=TextEditingController();
  final idmateriat=TextEditingController();
  final estado=TextEditingController();
  final descripcion=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Materia estGlob=Materia(
      idmateria: "",
      nombre: "",
      semestre: "",
      docente: ""
  );
  List<Materia> data = [];

  void actualizarLista() async{
    List<Materia> temp=await DB.mostrarTodos();
    setState(() {
      data=temp;
    });
  }

  Tarea estGlobT=Tarea(
      idtarea: 0,
      idmateria: "",
      entrega: "",
      descripcion: ""
  );
  List<Tarea> data2=[];

  void actualizarTareas() async{
    List<Tarea> tempT=await DB.mostrarTodasTareas();
    setState(() {
      data2=tempT;
    });
  }

  Tarea estGlobTP=Tarea(
      idtarea: 0,
      idmateria: "",
      entrega: "",
      descripcion: ""
  );
  List<Tarea> data2P=[];

  void actualizarTareasP() async{
    List<Tarea> tempT=await DB.mostrarTareasPosteriores();
    setState(() {
      data2P=tempT;
    });
  }

  @override
  void initState(){
    actualizarLista();
    actualizarTareas();
    actualizarTareasP();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${titulo}"),
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text("Alumno",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white
                        ),
                      )
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/fondo.jpeg"),
                  fit: BoxFit.fill
                )
              ),
            ),
            SizedBox(height: 30,),
            _item(Icons.add, "Agregar materia", 0),
            _item(Icons.edit,"Administrar materia",1),
            _item(Icons.house, "Tareas", 2)
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon,String text,int indi){
    return ListTile(
      onTap: (){
        setState(() {
          _index=indi;
          if(indi==0){
            titulo="📚 Agregar materia";
          }if(indi==1){
            titulo="📓 Administrar materias";
          }if(indi==2){
            titulo="📄 Tareas";
          }
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [
          SizedBox(height: 15,),
          Expanded(child: Icon(icon,size: 30,)),
          SizedBox(height: 10,),
          Expanded(child: Text(text,style: TextStyle(fontSize: 16)),flex: 6,),

        ],
      ),
    );
  }

  Widget dinamico(){
    switch (_index){
      case 0:{
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/materia.jpeg"),
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text("📚 Agregar nueva materia",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                    children: [
                      TextField(
                        controller: idmateria,
                        decoration: InputDecoration(
                          labelText: "Id de la materia",
                        ),
                      ),
                      TextField(
                        controller: nombreM,
                        decoration: InputDecoration(
                            labelText: "Nombre de la materia"
                        ),
                      ),
                      TextFormField(
                        controller: semestre,
                        decoration: InputDecoration(
                          labelText: 'Semestre',
                        ),
                        validator: (value) {
                          if (value!.isEmpty || !RegExp(r'^[A-Z]{3}-[A-Z]{3}\d{4}$').hasMatch(value!)) {
                            return "Formato inválido. Debe ser: AGO-DIC2023";
                          }
                          return null;
                        },
                      ),
                      TextField(
                        controller: docente,
                        decoration: InputDecoration(
                            labelText: "Docente"
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                if (_formKey.currentState!.validate()) {
                                  var temp=Materia(
                                    idmateria: idmateria.text,
                                    nombre: nombreM.text,
                                    semestre: semestre.text,
                                    docente: docente.text,
                                  );
                                  DB.insertar(temp).then((value){
                                    setState(() {
                                      titulo="Se inserto correctamente👍🏻";
                                      _index=1;
                                    });
                                    idmateria.text="";
                                    nombreM.text="";
                                    semestre.text="";
                                    docente.text="";
                                    actualizarLista();
                                  });// La validación es exitosa, puedes realizar la acción deseada aquí.
                                }

                              },
                              child: Text("Agregar")
                          ),
                          ElevatedButton(
                              onPressed: (){

                              },
                              child: Text("Limpiar")),
                        ],
                      )

                    ],
                  ),
                  ),
                )
              ],
            ),
          ),
        );//INTERFAZ DE AGREGAR MATERIA
      }
      case 1:{
        return Column(
          children: <Widget>[
            Image(image: AssetImage("assets/tarea.jpeg")),
            SizedBox(height: 20,),
            Text("Seleccione materia para agreagar tarea",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(height: 20,),
            Expanded(child:
              ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, indice){
                  return ListTile(
                    title: Text("${data[indice].nombre}"),
                    subtitle: Text("Semestre: ${data[indice].semestre}\nDocente:${data[indice].docente}"),
                    leading: CircleAvatar(child: Text("${data[indice].idmateria}"), radius: 10,),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: (){
                            estGlob=data[indice];
                            actualizarM(data[indice], indice);
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: (){
                            DB.eliminar(data[indice].idmateria).then((value){
                            setState(() {
                              titulo="Se elimino correctamente👍🏻";
                            });
                              actualizarLista();
                            actualizarTareas();
                            actualizarTareasP();
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                    onTap: (){
                      estGlob=data[indice];
                      agregarTarea(data[indice], indice);
                      setState(() {
                        idmateriat.text=data[indice].idmateria;
                      });
                      actualizarLista();
                      actualizarTareasP();
                      actualizarTareasP();
                    },
                  );
              }),
            )
          ],
        );//INTERFAZ DE ADMIN MATERIA
      }
      case 2:{
        return Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text("Tareas de HOY!!",style: TextStyle(fontSize: 20),),
            Expanded(child: ListView.builder(
                itemCount: data2.length,
                itemBuilder: (context, indice){
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amberAccent,
                      ),
                      height: 75,
                      child: ListTile(
                        title: Text("${data2[indice].descripcion}"),
                        subtitle: Text("Fecha de entrega: ${data2[indice].entrega}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: (){
                                estGlobT=data2[indice];
                                actualizarT(data2[indice], indice);
                                setState(() {
                                  actualizarTareas();
                                });
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: (){
                                DB.eliminarT(data2[indice].idtarea).then((value){
                                  setState(() {
                                    titulo="Se elimino correctamente👍🏻";
                                  });
                                  actualizarTareas();
                                });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
            Text("Tareas proximas",style: TextStyle(fontSize: 20),),
            Expanded(
                child: ListView.builder(
                itemCount: data2P.length,
                itemBuilder: (context, indice){
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amberAccent,
                      ),
                      height: 75,
                      child: ListTile(
                        title: Text("${data2P[indice].descripcion}"),
                        subtitle: Text("Fecha de entrega: ${data2P[indice].entrega}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: (){
                                estGlobTP=data2P[indice];
                                actualizarTP(data2P[indice], indice);
                                setState(() {
                                  actualizarTareasP();
                                });
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: (){
                                DB.eliminarT(data2P[indice].idtarea).then((value){
                                  setState(() {
                                    titulo="Se elimino correctamente👍🏻";
                                  });
                                  actualizarTareasP();
                                });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }))
          ],
        );//INTERFAZ DE ADMIN TAREAS
      }
      default:{
        return Center();
      }
    }
  }

  void agregarTarea(Materia p, int ind) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 50
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Agregar Tarea",
                      style: TextStyle(
                          fontSize: 25
                      ),
                    ),
                    TextField(
                      enabled: false,
                      controller: idmateriat,
                      decoration: InputDecoration(
                          labelText: "Materia"
                      ),
                    ),
                    TextFormField(
                      controller: estado,
                      decoration: InputDecoration(
                          labelText: "Fecha de entrega"
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^\d{4}/\d{2}/\d{2}$').hasMatch(value!)) {
                          return 'Formato de fecha no válido YYYY/MM/DD';
                        }
                        return null; // La entrada es válida.
                      },
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: descripcion,
                      decoration: InputDecoration(
                          labelText: "Descripcion"
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                var tempT = Tarea(
                                  idmateria: idmateriat.text,
                                  entrega: estado.text,
                                  descripcion: descripcion.text,
                                );
                                DB.insertarT(tempT).then((value) {
                                  setState(() {
                                    titulo = "Se inserto correctamente👍🏻";
                                  });
                                  idmateriat.text = "";
                                  estado.text = "";
                                  descripcion.text = "";
                                  actualizarTareas();
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Text("Agregar")
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                              idmateriat.text = "";
                              estado.text = "";
                              descripcion.text = "";
                            },
                            child: Text("Cancelar")
                        ),
                      ],
                    )
                  ]
              ),
            ),
          );
        }
    );
  }

  void actualizarM(Materia p, int ind){
    nombreM.text = estGlob.nombre;
    semestre.text = estGlob.semestre;
    docente.text = estGlob.docente;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
                padding: EdgeInsets.all(40),
                children: [
                  SizedBox(height: 20,),
                  Text("Idmateria: ${estGlob.idmateria}", style: TextStyle(fontSize: 20),),
                  SizedBox(height: 30,),
                  TextField(
                    controller: nombreM,
                    decoration: InputDecoration(
                        labelText: "Nombre:"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: semestre,
                    decoration: InputDecoration(
                      labelText: 'Semestre',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'^[A-Z]{3}-[A-Z]{3}\d{4}$').hasMatch(value!)) {
                        return "Formato inválido. Debe ser: AGO-DIC2023";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: docente,
                    decoration: InputDecoration(
                        labelText: "Docente:"
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            estGlob.nombre = nombreM.text;
                            estGlob.semestre = semestre.text;
                            estGlob.docente = docente.text;
                            DB.actualizar(estGlob).then((value) {
                              if (value > 0) {
                                setState(() {
                                  titulo = "Se actualizo correctamente👍🏻";
                                });
                                nombreM.text = "";
                                semestre.text = "";
                                docente.text = "";
                                estGlob = Materia(idmateria: "",
                                    nombre: "",
                                    semestre: "",
                                    docente: "");
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        child: Text("Actualizar"),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          nombreM.text="";
                          semestre.text="";
                          docente.text="";
                          estGlob = Materia(idmateria: "", nombre: "", semestre: "", docente: "");
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"),
                      ),
                    ],
                  )
                ],
              ),
          );
        }
    );
  }

  void actualizarT(Tarea p, int ind){
    idmateriat.text=estGlobT.idmateria;
    estado.text = estGlobT.entrega;
    descripcion.text = estGlobT.descripcion;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder) {
          return ListView(
            padding: EdgeInsets.all(40),
            children: [
              SizedBox(height: 20,),
              Text("Id Tarea: ${estGlobT.idtarea}", style: TextStyle(fontSize: 20),),
              SizedBox(height: 30,),
              TextField(
                controller: estado,
                decoration: InputDecoration(
                    labelText: "Fecha de entrega:"
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: descripcion,
                decoration: InputDecoration(
                    labelText: "Descripcion:"
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      estGlobT.idmateria=idmateriat.text;
                      estGlobT.entrega = estado.text;
                      estGlobT.descripcion = descripcion.text;
                      DB.actualizarT(estGlobT).then((value) {
                        if(value>0){
                          setState(() {
                            titulo = "Se actualizo correctamente👍🏻";
                          });
                          idmateriat.text="";
                          estado.text="";
                          descripcion.text="";
                          estGlobT = Tarea(idtarea: 0,idmateria: "", entrega: "", descripcion: "");
                          Navigator.pop(context);
                        }
                        actualizarTareas();
                      });
                    },
                    child: Text("Actualizar"),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      idmateriat.text="";
                      estado.text="";
                      descripcion.text="";
                      estGlobT = Tarea(idtarea: 0,idmateria: "", entrega: "", descripcion: "");
                      Navigator.pop(context);
                      actualizarTareas();
                    },
                    child: Text("Cancelar"),
                  ),
                ],
              )
            ],
          );
        }
    );
  }

  void actualizarTP(Tarea p, int ind){
    idmateriat.text=estGlobTP.idmateria;
    estado.text = estGlobTP.entrega;
    descripcion.text = estGlobTP.descripcion;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder) {
          return ListView(
            padding: EdgeInsets.all(40),
            children: [
              SizedBox(height: 20,),
              Text("Id Tarea: ${estGlobTP.idtarea}", style: TextStyle(fontSize: 20),),
              SizedBox(height: 30,),
              TextField(
                controller: estado,
                decoration: InputDecoration(
                    labelText: "Fecha de entrega:"
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: descripcion,
                decoration: InputDecoration(
                    labelText: "Descripcion:"
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      estGlobTP.idmateria=idmateriat.text;
                      estGlobTP.entrega = estado.text;
                      estGlobTP.descripcion = descripcion.text;
                      DB.actualizarT(estGlobTP).then((value) {
                        if(value>0){
                          setState(() {
                            titulo = "Se actualizo correctamente👍🏻";
                          });
                          idmateriat.text="";
                          estado.text="";
                          descripcion.text="";
                          estGlobTP = Tarea(idtarea: 0,idmateria: "", entrega: "", descripcion: "");
                          Navigator.pop(context);
                        }
                        actualizarTareasP();
                      });
                    },
                    child: Text("Actualizar"),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      idmateriat.text="";
                      estado.text="";
                      descripcion.text="";
                      estGlobTP = Tarea(idtarea: 0,idmateria: "", entrega: "", descripcion: "");
                      Navigator.pop(context);
                      actualizarTareasP();
                    },
                    child: Text("Cancelar"),
                  ),
                ],
              )
            ],
          );
        }
    );
  }


}
