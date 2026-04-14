import 'package:flutter/material.dart';
import 'diccionarioempleado.dart';

class VerEmpleados extends StatelessWidget {
  const VerEmpleados({super.key});

  @override
  Widget build(BuildContext context) {
    // Convertimos los valores del diccionario a una lista para el ListView
    final lista = datosEmpleado.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Nómina de Empleados"), backgroundColor: const Color(0xFFF7C02F)),
      body: lista.isEmpty 
        ? const Center(child: Text("No hay empleados registrados"))
        : ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final emp = lista[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${emp.id}")),
                  title: Text(emp.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(emp.puesto),
                  trailing: Text("\$${emp.salario}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
    );
  }
}