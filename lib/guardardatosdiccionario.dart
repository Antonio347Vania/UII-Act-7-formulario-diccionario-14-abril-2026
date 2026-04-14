import 'claseempleado.dart';
import 'diccionarioempleado.dart';

class GuardarDatosAgente {
  static void registrar(String nombre, String puesto, double salario) {
    // Crear el nuevo objeto con el ID actual
    Empleado nuevo = Empleado(
      id: contadorId,
      nombre: nombre,
      puesto: puesto,
      salario: salario,
    );
    
    // Guardar en el diccionario usando el ID como clave
    datosEmpleado[contadorId] = nuevo;
    
    // Incrementar para el siguiente registro
    contadorId++;
  }
}