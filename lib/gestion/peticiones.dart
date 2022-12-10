import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart' as sql;

class databaseConsulta {
  static Future<void> crearTabla(sql.Database database) async {
    await database.execute("""CREATE TABLE posicion(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          coordenadas TEXT, 
          fecha TEXT
          )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("reto4.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await crearTabla(database);
    });
  }

  static Future<List<Map<String, dynamic>>> verUbicaciones() async {
    final base = await databaseConsulta.db();
    return base.query("posicion", orderBy: "fecha");
  }

  static Future<void> eliminarPosicion(int idPOS) async {
    final base = await databaseConsulta.db();
    base.delete("posicion", where: "id=?", whereArgs: [idPOS]);
  }

  static Future<void> eliminarTodo() async {
    final base = await databaseConsulta.db();
    base.delete("posicion");
  }

  static Future<void> guardarPosicion(coordenada, fecha) async {
    final base = await databaseConsulta.db();
    final datos = {"coordenadas": coordenada, "fecha": fecha};
    await base.insert("posicion", datos,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
