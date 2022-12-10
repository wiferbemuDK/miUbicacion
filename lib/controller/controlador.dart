import 'package:get/get.dart';
import 'package:reto_geo_localizacion/gestion/peticiones.dart';

class controladorGeneral extends GetxController {
  final Rxn<List<Map<String, dynamic>>> _listaPosisiones =
      Rxn<List<Map<String, dynamic>>>();
  final _unaPosicion = "".obs;

  //_______________________________________//
  void cargaunaPosision(String X) {
    _unaPosicion.value = X;
  }

  String get unaPosicion => _unaPosicion.value;
  //______________________________________//

  void cargalistaPosiciones(List<Map<String, dynamic>> X) {
    _listaPosisiones.value = X;
  }

  List<Map<String, dynamic>>? get listaPosisiones => _listaPosisiones.value;
  //_____________________________________//

  Future<void> CargarFullDB() async {
    final datos = await databaseConsulta.verUbicaciones();
    cargalistaPosiciones(datos);
  }
}
