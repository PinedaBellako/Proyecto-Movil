import 'package:flutter/material.dart';

class ActProfesorScreen extends StatefulWidget {
  const ActProfesorScreen({super.key});

  @override
  State<ActProfesorScreen> createState() => _ActProfesorScreenState();
}

class _ActProfesorScreenState extends State<ActProfesorScreen> {
  // Datos simulados para las clases
  final Map<String, List<Map<String, dynamic>>> clases = {
    "Matemáticas": [
      {"nombre": "Juan Pérez", "asistencias": 20, "faltas": 5, "retardos": 2},
      {"nombre": "María López", "asistencias": 18, "faltas": 7, "retardos": 3},
    ],
    "Historia": [
      {
        "nombre": "Carlos García",
        "asistencias": 22,
        "faltas": 3,
        "retardos": 1
      },
      {"nombre": "Ana Torres", "asistencias": 19, "faltas": 6, "retardos": 4},
    ],
  };

  // Clase seleccionada
  String _claseSeleccionada = "Matemáticas";

  @override
  Widget build(BuildContext context) {
    // Obtener los alumnos de la clase seleccionada
    final alumnos = clases[_claseSeleccionada]!;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 76, 163, 97), // Verde oscuro
                  Color(0xFF000000), // Negro
                ],
              ),
            ),
          ),
          // Contenido principal
          Column(
            children: [
              const SizedBox(height: 50),
              // Título centrado
              Center(
                child: Text(
                  'Actividad de Alumnos',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Menú desplegable para seleccionar la clase
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButton<String>(
                  value: _claseSeleccionada,
                  dropdownColor: Colors.black, // Fondo negro del menú
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.white,
                  ),
                  items: clases.keys.map((String clase) {
                    return DropdownMenuItem<String>(
                      value: clase,
                      child: Text(clase),
                    );
                  }).toList(),
                  onChanged: (String? nuevaClase) {
                    setState(() {
                      _claseSeleccionada = nuevaClase!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Tabla de datos estilizada
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      borderRadius:
                          BorderRadius.circular(15), // Bordes redondeados
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Sombra suave
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          15), // Asegura que el borde sea redondeado
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            Colors
                                .grey[200], // Fondo gris claro para encabezados
                          ),
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Nombre del Alumno',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Texto negro
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Asistencias',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Texto negro
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Faltas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Texto negro
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Retardos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Texto negro
                                ),
                              ),
                            ),
                          ],
                          rows: alumnos
                              .map(
                                (alumno) => DataRow(
                                  cells: [
                                    DataCell(Text(
                                      alumno["nombre"],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black, // Texto negro
                                      ),
                                    )),
                                    DataCell(Text(
                                      alumno["asistencias"].toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black, // Texto negro
                                      ),
                                    )),
                                    DataCell(Text(
                                      alumno["faltas"].toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black, // Texto negro
                                      ),
                                    )),
                                    DataCell(Text(
                                      alumno["retardos"].toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black, // Texto negro
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
}
