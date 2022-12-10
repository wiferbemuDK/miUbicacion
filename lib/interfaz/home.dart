import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:reto_geo_localizacion/controller/controlador.dart';
import 'package:reto_geo_localizacion/gestion/peticiones.dart';
import 'package:reto_geo_localizacion/interfaz/listaUbicaciones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Guardar Ubicación',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Mi Ubicación'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

controladorGeneral Control = Get.find();

class _MyHomePageState extends State<MyHomePage> {
  void permisoPosicion() async {
    Position posicion = await databaseConsulta.determinePosition();
    print(posicion.toString());
    Control.cargaunaPosision(posicion.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        type: AlertType.warning,
                        context: context,
                        title: "CUIDADO!!!",
                        buttons: [
                          DialogButton(
                              color: Colors.cyanAccent[200],
                              child: Text("Si"),
                              onPressed: () {
                                databaseConsulta.eliminarTodo();
                                Control.CargarFullDB();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Colors.red[200],
                              child: Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        desc:
                            "Esta a punto de eliminar todas las ubicaciones, Continuar?")
                    .show();
              },
              icon: Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: listaUbicaciones(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          permisoPosicion();
          Alert(
                  title: "ATENCION",
                  desc: "Esta seguro de querer guardar la ubicacion  " +
                      Control.unaPosicion +
                      "  ?",
                  type: AlertType.info,
                  buttons: [
                    DialogButton(
                        color: Colors.blue[400],
                        child: Text("Si"),
                        onPressed: () {
                          databaseConsulta.guardarPosicion(
                              Control.unaPosicion, DateTime.now().toString());
                          Control.CargarFullDB();
                          Navigator.pop(context);
                        }),
                    DialogButton(
                        color: Colors.amber[400],
                        child: Text("No"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  context: context)
              .show();
        },
        child: Icon(Icons.location_on_rounded),
      ),
    );
  }
}
