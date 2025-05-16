import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pantalla para que el profesor vea la actividad de los alumnos en sus clases.
/// Permite seleccionar una clase, ver la lista de alumnos y sus asistencias/retardos.
class ActProfesorScreen extends StatefulWidget {
  const ActProfesorScreen({super.key});

  @override
  State<ActProfesorScreen> createState() => _ActProfesorScreenState();
}

class _ActProfesorScreenState extends State<ActProfesorScreen> {
  // --- FORMATO Y COLORES ---
  final Color colorFondoInicio = const Color.fromARGB(255, 76, 163, 97);
  final Color colorFondoFin = const Color(0xFF000000);
  final Color colorTextoTitulo = Colors.white;
  final Color colorTextoDropdown = Colors.white;
  final Color colorDropdownFondo = Colors.black;
  final Color colorBordeDropdown = Colors.white;
  final Color colorTablaFondo = Colors.white;
  final Color colorTablaEncabezado = const Color(0xFFF5F5F5);
  final Color colorTablaTexto = Colors.black;
  final Color colorSombra = Colors.black;
  final double radioBordeTabla = 15.0;
  final double espacioColumnasTabla = 50.0;
  final double tamanoTextoTitulo = 24.0;
  final double tamanoTextoTabla = 14.0;
  final double tamanoTextoEncabezado = 16.0;

  List<Map<String, String>> clasesProfesor = []; // Lista de clases del profesor
  String? _codigoSeleccionado; // Código de la clase seleccionada
  List<Map<String, dynamic>> alumnos =
      []; // Lista de alumnos de la clase seleccionada
  int totalAsistencias = 0; // Total de asistencias de la clase

  // --- WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente verde a negro
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
          Column(
            children: [
              const SizedBox(height: 50),
              // Título principal de la pantalla
              Center(
                child: Text(
                  'Actividad de Alumnos',
                  style: TextStyle(
                    fontSize: tamanoTextoTitulo,
                    color: colorTextoTitulo,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown para seleccionar la clase a consultar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButton<String>(
                  value: _codigoSeleccionado,
                  dropdownColor: colorDropdownFondo,
                  icon: Icon(Icons.arrow_drop_down, color: colorTextoDropdown),
                  isExpanded: true,
                  style: TextStyle(color: colorTextoDropdown, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: colorBordeDropdown,
                  ),
                  items: clasesProfesor.isEmpty
                      ? []
                      : clasesProfesor.map((clase) {
                          return DropdownMenuItem<String>(
                            value: clase['codigo'],
                            child: Text(clase['nombre'] ?? clase['codigo']!),
                          );
                        }).toList(),
                  onChanged: (String? nuevoCodigo) {
                    setState(() {
                      _codigoSeleccionado = nuevoCodigo!;
                    });
                    cargarAlumnosDeClase(nuevoCodigo!);
                  },
                  hint: Text(
                    'Selecciona una clase',
                    style: TextStyle(color: colorTextoDropdown),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tabla de alumnos con asistencias y retardos
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorTablaFondo,
                      borderRadius: BorderRadius.circular(radioBordeTabla),
                      boxShadow: [
                        BoxShadow(
                          color: colorSombra.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radioBordeTabla),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            colorTablaEncabezado,
                          ),
                          columnSpacing: espacioColumnasTabla,
                          columns: [
                            // Encabezado: Nombre del alumno
                            DataColumn(
                              label: Text(
                                'Nombre',
                                style: TextStyle(
                                  fontSize: tamanoTextoEncabezado,
                                  fontWeight: FontWeight.bold,
                                  color: colorTablaTexto,
                                ),
                              ),
                            ),
                            // Encabezado: Asistencias
                            DataColumn(
                              label: Text(
                                'Asistencias',
                                style: TextStyle(
                                  fontSize: tamanoTextoEncabezado,
                                  fontWeight: FontWeight.bold,
                                  color: colorTablaTexto,
                                ),
                              ),
                            ),
                            // Encabezado: Retardos
                            DataColumn(
                              label: Text(
                                'Retardos',
                                style: TextStyle(
                                  fontSize: tamanoTextoEncabezado,
                                  fontWeight: FontWeight.bold,
                                  color: colorTablaTexto,
                                ),
                              ),
                            ),
                          ],
                          // Filas de la tabla: alumnos y total
                          rows: alumnos.isEmpty
                              ? []
                              : alumnos
                                  .map(
                                    (alumno) => DataRow(
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              alumno["nombre"],
                                              style: TextStyle(
                                                fontSize: tamanoTextoTabla,
                                                color: colorTablaTexto,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(
                                          alumno["asistencias"].toString(),
                                          style: TextStyle(
                                            fontSize: tamanoTextoTabla,
                                            color: colorTablaTexto,
                                          ),
                                        )),
                                        DataCell(Text(
                                          alumno["retardos"].toString(),
                                          style: TextStyle(
                                            fontSize: tamanoTextoTabla,
                                            color: colorTablaTexto,
                                          ),
                                        )),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- FUNCIONES Y LÓGICA ---

  @override
  void initState() {
    super.initState();
    cargarClasesDelProfesor();
    imprimirUsuario();
  }

  /// Carga las clases del profesor desde Firestore y actualiza el dropdown.
  Future<void> cargarClasesDelProfesor() async {
    final prefs = await SharedPreferences.getInstance();
    final String nombreUsuario = prefs.getString('nombreUsuario') ?? '';

    final clasesSnapshot = await FirebaseFirestore.instance
        .collection('Proyecto')
        .doc(nombreUsuario)
        .collection('clases')
        .get();

    final clases = clasesSnapshot.docs
        .map((doc) => {
              "codigo": doc.id,
              "nombre": doc.data()['nombreClase']?.toString() ?? doc.id,
            })
        .toList();

    setState(() {
      clasesProfesor = clases;
      // Selecciona la primera clase automáticamente si hay clases
      if (clasesProfesor.isNotEmpty) {
        _codigoSeleccionado = clasesProfesor.first['codigo'];
        cargarAlumnosDeClase(_codigoSeleccionado!);
      }
    });
  }

  /// Carga los alumnos de la clase seleccionada y sus asistencias/retardos.
  /// También obtiene el total de asistencias de la clase.
  Future<void> cargarAlumnosDeClase(String codigoClase) async {
    final prefs = await SharedPreferences.getInstance();
    final String nombreUsuario = prefs.getString('nombreUsuario') ?? '';

    final alumnosSnapshot = await FirebaseFirestore.instance
        .collection('Proyecto')
        .doc(nombreUsuario)
        .collection('clases')
        .doc(codigoClase)
        .collection('alumnos')
        .get();

    int total = 0;
    // Obtiene el documento 'Total' para mostrar el total de asistencias
    final totalDoc = await FirebaseFirestore.instance
        .collection('Proyecto')
        .doc(nombreUsuario)
        .collection('clases')
        .doc(codigoClase)
        .collection('alumnos')
        .doc('Total')
        .get();
    if (totalDoc.exists) {
      total = totalDoc.data()?['asistencia'] ?? 0;
    }

    // Construye la lista de alumnos (incluye una fila para el total)
    final alumnosList = [
      {
        "nombre": "Total",
        "asistencias": total,
        "retardos": "",
      },
      ...alumnosSnapshot.docs.where((doc) => doc.id != 'Total').map((doc) => {
            "nombre": doc.id,
            "asistencias": doc.data()['asistencias'] ?? 0,
            "retardos": doc.data()['retardos'] ?? 0,
          })
    ];

    setState(() {
      totalAsistencias = total;
      alumnos = alumnosList;
    });
  }

  /// Imprime el usuario guardado en SharedPreferences (para debug).
  Future<void> imprimirUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final String nombreUsuario = prefs.getString('nombreUsuario') ?? '';
    print('Usuario guardado en SharedPreferences: $nombreUsuario');
  }

  /// Elimina una clase del profesor en Firestore.
  /// Muestra un mensaje de éxito o error.
  Future<void> eliminarClase(String codigo) async {
    final prefs = await SharedPreferences.getInstance();
    final String nombreProfesor = prefs.getString('nombreUsuario') ?? '';

    final docRef = FirebaseFirestore.instance
        .collection('Proyecto')
        .doc(nombreProfesor)
        .collection('clases')
        .doc(codigo);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      try {
        await docRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clase eliminada correctamente')),
        );
        await cargarClasesDelProfesor();
        setState(() {
          _codigoSeleccionado = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la clase: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No existe una clase con ese código')),
      );
    }
  }
}
