import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reto_geo_localizacion/controller/controlador.dart';
import 'package:reto_geo_localizacion/gestion/peticiones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class listaUbicaciones extends StatefulWidget {
  const listaUbicaciones({super.key});

  @override
  State<listaUbicaciones> createState() => _listaUbicacionesState();
}

class _listaUbicacionesState extends State<listaUbicaciones> {
  controladorGeneral Control = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Control.CargarFullDB();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: Control.listaPosisiones?.isEmpty == false
              ? ListView.builder(
                  itemCount: Control.listaPosisiones!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.location_on_outlined),
                        trailing: IconButton(
                            onPressed: () {
                              Alert(
                                      type: AlertType.warning,
                                      context: context,
                                      title: "CUIDADO!!!",
                                      buttons: [
                                        DialogButton(
                                            color: Colors.blueAccent[200],
                                            child: Text("Si"),
                                            onPressed: () {
                                              databaseConsulta.eliminarPosicion(
                                                  Control.listaPosisiones![
                                                      index]["id"]);
                                              Control.CargarFullDB();
                                              Navigator.pop(context);
                                            }),
                                        DialogButton(
                                            color: Colors.orangeAccent[200],
                                            child: Text("No"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            })
                                      ],
                                      desc:
                                          "Esta a punto de eliminar un registro, continuar?")
                                  .show();
                            },
                            icon: Icon(Icons.delete_forever_outlined)),
                        title: Text(
                            Control.listaPosisiones![index]["coordenadas"]),
                        subtitle:
                            Text(Control.listaPosisiones![index]["fecha"]),
                      ),
                    );
                  },
                )
              : Center(child: LinearProgressIndicator()),
        ));
  }
}
