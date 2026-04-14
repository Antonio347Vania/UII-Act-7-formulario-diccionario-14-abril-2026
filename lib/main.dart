import 'package:flutter/material.dart';
import 'inicio.dart';
import 'capturaempleados.dart';
import 'verempleados.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
    '/': (context) => Inicio(),
    '/captura': (context) => CapturaEmpleados(),
    '/lista': (context) => VerEmpleados(),
  },
));