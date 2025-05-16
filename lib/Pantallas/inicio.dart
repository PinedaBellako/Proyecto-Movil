import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pantalla de inicio para alumnos.
/// Muestra las materias inscritas, asistencias, retardos y permite unirse a una clase.
class InicioScreen extends StatefulWidget {
  final String nombreUsuario;
  final bool esProfesor;
  final Function cambiarPantalla;

  const InicioScreen({
    super.key,
    required this.nombreUsuario,
    required this.esProfesor,
    required this.cambiarPantalla,
  });

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  // --- FORMATO Y ESTILOS ---
  final Color colorFondoInicio = const Color.fromARGB(255, 76, 163, 97);
  final Color colorFondoFin = const Color(0xFF000000);
  final Color colorCard = Colors.white;
  final Color colorCardTexto = Colors.black;
  final Color colorTitulo = Colors.white;
  final Color colorBoton = const Color.fromARGB(255, 93, 255, 142);
  final Color colorBotonTexto = Colors.black;
  final double tamanoTitulo = 20.0;
  final double tamanoTexto = 16.0;
  final double radioBorde = 12.0;

  List<Map<String, dynamic>> materias = [];

  // --- WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título de bienvenida con el nombre del usuario
        title: Text(
          'Bienvenido, ${widget.nombreUsuario}',
          style: GoogleFonts.poppins(
            fontSize: tamanoTitulo,
            color: colorTitulo,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 27, 19),
      ),
      body: Stack(
        children: [
          // Fondo degradado verde a negro
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorFondoInicio,
                  colorFondoFin,
                ],
              ),
            ),
          ),
          // Contenido principal desplazable
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Sección de Acciones Rápidas
                  Text(
                    'Acciones Rápidas',
                    style: GoogleFonts.poppins(
                      fontSize: tamanoTitulo,
                      color: colorTitulo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón para unirse a una clase
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _mostrarFormularioUnirseClase(context);
                          },
                          icon: const Icon(Icons.group_add, size: 30),
                          label: Text(
                            'Unirme a una Clase',
                            style: GoogleFonts.poppins(fontSize: tamanoTexto),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorBoton,
                            foregroundColor: colorBotonTexto,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Tabla de materias, asistencias y retardos con estilo personalizado
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorCard,
                      borderRadius: BorderRadius.circular(radioBorde),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado de la tabla
                        Row(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Materia',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Asistencias',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Retardos',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Filas dinámicas con la información de cada materia
                        ...materias.map((materia) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child:
                                          Text(materia['materia'].toString()),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        materia['asistencias'].toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        materia['retardos'].toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- FUNCIONES Y LÓGICA ---
  @override
  void initState() {
    super.initState();
    cargarMaterias();
  }

  /// Carga las materias del usuario desde Firestore y actualiza la lista.
  /// También obtiene las asistencias y retardos de cada materia.
  Future<void> cargarMaterias() async {
    final prefs = await SharedPreferences.getInstance();
    final String usuario = prefs.getString('usuario') ?? 'AlumnoDesconocido';
    final String nombreUsuario = prefs.getString('nombreUsuario') ?? usuario;

    // Consulta todas las materias del usuario
    final snapshot = await FirebaseFirestore.instance
        .collection('Proyecto')
        .doc('Usuarios')
        .collection(usuario)
        .get();

    List<Map<String, dynamic>> materiasTemp = [];

    for (var doc in snapshot.docs) {
      if (doc.id.trim().toLowerCase() == 'datos')
        continue; // Ignora documento de datos generales
      final data = doc.data();
      final profesor = data['profesor'] ?? '';
      final codigo = data['codigo'] ?? '';
      final nombreMateria = doc.id;

      // Busca asistencias y retardos en la colección de la clase
      final alumnoDoc = await FirebaseFirestore.instance
          .collection('Proyecto')
          .doc(profesor)
          .collection('clases')
          .doc(codigo)
          .collection('alumnos')
          .doc(nombreUsuario)
          .get();

      final asistencias = alumnoDoc.data()?['asistencias'] ?? 0;
      final retardos = alumnoDoc.data()?['retardos'] ?? 0;

      materiasTemp.add({
        'materia': nombreMateria,
        'asistencias': asistencias,
        'retardos': retardos,
      });
    }

    setState(() {
      materias = materiasTemp;
    });
  }

  /// Muestra el formulario para unirse a una clase.
  /// El usuario debe ingresar el nombre del profesor y el código de la clase.
  void _mostrarFormularioUnirseClase(BuildContext context) {
    final TextEditingController codigoClaseController = TextEditingController();
    final TextEditingController nombreProfesorController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Unirse a una Clase',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo para el nombre del profesor
            TextField(
              controller: nombreProfesorController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nombre del Profesor',
                labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: const Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 10),
            // Campo para el código de la clase
            TextField(
              controller: codigoClaseController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Código de Clase',
                labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: const Color(0xFF424242),
              ),
            ),
          ],
        ),
        actions: [
          // Botón para cancelar el formulario
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          // Botón para unirse a la clase
          ElevatedButton(
            onPressed: () async {
              final String nombreProfesor =
                  nombreProfesorController.text.trim();
              final String codigoClase =
                  codigoClaseController.text.trim().toUpperCase();

              try {
                // Verifica si la clase existe en Firestore
                final claseSnapshot = await FirebaseFirestore.instance
                    .collection('Proyecto')
                    .doc(nombreProfesor)
                    .collection('clases')
                    .doc(codigoClase)
                    .get();

                if (!claseSnapshot.exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No existe una clase con ese código y profesor.')),
                  );
                  return;
                }

                final String nombreClase =
                    claseSnapshot.data()?['nombreClase'] ?? 'Clase desconocida';

                final prefs = await SharedPreferences.getInstance();
                final String usuario =
                    prefs.getString('usuario') ?? 'AlumnoDesconocido';
                final String nombreAlumno =
                    prefs.getString('nombreUsuario') ?? usuario;

                // Guarda la materia en la colección del usuario
                await FirebaseFirestore.instance
                    .collection('Proyecto')
                    .doc('Usuarios')
                    .collection(usuario)
                    .doc(nombreClase)
                    .set({
                  'profesor': nombreProfesor,
                  'codigo': codigoClase,
                });

                // Agrega al alumno en la lista de alumnos de la clase
                await FirebaseFirestore.instance
                    .collection('Proyecto')
                    .doc(nombreProfesor)
                    .collection('clases')
                    .doc(codigoClase)
                    .collection('alumnos')
                    .doc(nombreAlumno)
                    .set({
                  'usuario': usuario,
                  'asistencias': 0,
                  'retardos': 0,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Te has inscrito a la clase "$nombreClase".'),
                  ),
                );

                Navigator.pop(context);
                cargarMaterias();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al unirse a la clase: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorBoton,
              foregroundColor: colorBotonTexto,
            ),
            child: const Text('Unirse'),
          ),
        ],
      ),
    );
  }
}
