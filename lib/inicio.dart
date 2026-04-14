import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7C02F), // Amarillo Soriana
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.network('https://raw.githubusercontent.com/Antonio347Vania/im-genes-para-flutter-6toI-11-Feb-2026/refs/heads/main/unnamed-removebg-preview.png'),
              ),
            ),
            const SizedBox(height: 20),
            const Text("SORIANA VANIA", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("PLATAFORMA ANTIGRAVITY", style: TextStyle(fontSize: 14, letterSpacing: 2)),
            const SizedBox(height: 50),
            _botonRuta(context, "CAPTURAR EMPLEADOS", Icons.add_reaction, '/captura'),
            const SizedBox(height: 20),
            _botonRuta(context, "VER NÓMINA", Icons. people_alt, '/lista'),
          ],
        ),
      ),
    );
  }

  Widget _botonRuta(BuildContext context, String texto, IconData icono, String ruta) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, ruta),
      icon: Icon(icono),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50), // Verde
        foregroundColor: Colors.white,
        fixedSize: const Size(280, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}