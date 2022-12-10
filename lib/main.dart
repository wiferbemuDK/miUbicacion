import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reto_geo_localizacion/controller/controlador.dart';
import 'package:reto_geo_localizacion/interfaz/home.dart';

void main() {
  Get.put(controladorGeneral());
  runApp(const MyApp());
}
