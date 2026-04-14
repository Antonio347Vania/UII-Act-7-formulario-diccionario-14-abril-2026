import 'package:flutter/material.dart';
import 'guardardatosdiccionario.dart';

class CapturaEmpleados extends StatefulWidget {
  const CapturaEmpleados({super.key});

  @override
  State<CapturaEmpleados> createState() => _CapturaEmpleadosState();
}

class _CapturaEmpleadosState extends State<CapturaEmpleados> {
  final _nombreController = TextEditingController();
  final _puestoController = TextEditingController();
  final _salarioController = TextEditingController();

  void _guardar() {
    if (_nombreController.text.isEmpty || _puestoController.text.isEmpty || _salarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Llene todos los campos")));
      return;
    }

    // Usamos el agente para guardar
    GuardarDatosAgente.registrar(
      _nombreController.text,
      _puestoController.text,
      double.parse(_salarioController.text),
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Empleado Guardado con Éxito")));
    
    // Limpiar campos
    _nombreController.clear();
    _puestoController.clear();
    _salarioController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Personal"), backgroundColor: const Color(0xFFF7C02F)),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Nombre del Empleado", Icons.person, _nombreController, TextInputType.text),
              const SizedBox(height: 15),
              _input("Puesto / Cargo", Icons.work, _puestoController, TextInputType.text),
              const SizedBox(height: 15),
              _input("Salario Mensual", Icons.monetization_on, _salarioController, TextInputType.number),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                child: const Text("GUARDAR EN DICCIONARIO", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, IconData icono, TextEditingController cont, TextInputType tipo) {
    return TextField(
      controller: cont,
      keyboardType: tipo,
      decoration: InputDecoration(
        prefixIcon: Icon(icono),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}