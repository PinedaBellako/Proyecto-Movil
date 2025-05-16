import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pantalla para profesores.
/// Permite crear clases, generar QR, ver historial y eliminar clases.
class profesor extends StatefulWidget {
  const profesor({
    super.key,
    required this.title,
    required this.cambiarPantalla,
  });

  final String title;
  final Function cambiarPantalla;

  @override
  State<profesor> createState() => _profesorState();
}

class _profesorState extends State<profesor> {
  // Controladores para los campos del formulario de clase
  final TextEditingController nombreClaseController = TextEditingController();
  final TextEditingController inicioClaseController = TextEditingController();
  final TextEditingController retardoController = TextEditingController();
  final TextEditingController cierreQRController = TextEditingController();

  // Lista para almacenar el historial de clases
  final List<Map<String, String>> historialClases = [];

  String? claseSeleccionada; // Clase seleccionada para generar QR

  @override
  void initState() {
    super.initState();
    _bajarClasesDeFirestore();
  }

  // --- DISEÑO Y WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado verde a negro
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 76, 163, 97),
                  Color.fromARGB(255, 9, 15, 9),
                ],
              ),
            ),
          ),
          // Contenido principal desplazable
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título
                  Text(
                    'Configuración de Clase',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Botón para abrir el formulario de crear clase
                  ElevatedButton.icon(
                    onPressed: _mostrarFormularioCrearClase,
                    icon: const Icon(Icons.add, size: 30),
                    label: Text(
                      'Crear Clase',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 93, 255, 142),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Dropdown para seleccionar clase
                  Card(
                    color: const Color(0xFF2C2C2C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selecciona una clase para generar QR:',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: claseSeleccionada,
                            items: historialClases.map((clase) {
                              return DropdownMenuItem<String>(
                                value: clase['codigo'],
                                child: Text(
                                  clase['nombre'] ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? nuevaClase) {
                              setState(() {
                                claseSeleccionada = nuevaClase;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF424242),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                            dropdownColor: Colors.grey[200],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para generar QR
                  ElevatedButton.icon(
                    onPressed: _mostrarQR,
                    icon: const Icon(Icons.qr_code, size: 30),
                    label: Text(
                      'Generar QR',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 93, 255, 142),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 37, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para mostrar clases con código
                  ElevatedButton.icon(
                    onPressed: _mostrarClasesConCodigo,
                    icon: const Icon(Icons.list, size: 30),
                    label: Text(
                      'Ver Clases',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 93, 255, 142),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para eliminar clase
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final TextEditingController codigoController =
                              TextEditingController();
                          return AlertDialog(
                            backgroundColor: const Color(0xFF2C2C2C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Text(
                              'Eliminar Clase',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            content: TextField(
                              controller: codigoController,
                              style: GoogleFonts.poppins(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Código de la Clase',
                                labelStyle:
                                    GoogleFonts.poppins(color: Colors.white),
                                filled: true,
                                fillColor: const Color(0xFF424242),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final codigo = codigoController.text
                                      .trim()
                                      .toUpperCase();
                                  if (codigo.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Ingresa el código de la clase')),
                                    );
                                    return;
                                  }
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final String nombreProfesor =
                                      prefs.getString('nombreUsuario') ??
                                          'ProfesorDesconocido';
                                  final docRef = FirebaseFirestore.instance
                                      .collection('Proyecto')
                                      .doc(nombreProfesor)
                                      .collection('clases')
                                      .doc(codigo);

                                  final docSnapshot = await docRef.get();
                                  if (!docSnapshot.exists) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'No existe una clase con ese código')),
                                    );
                                    return;
                                  }

                                  try {
                                    await docRef.delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Clase eliminada correctamente')),
                                    );
                                    await _bajarClasesDeFirestore();
                                    Navigator.pop(context);
                                    setState(() {
                                      claseSeleccionada = null;
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error al eliminar la clase: $e')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 93, 255, 142),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, size: 30),
                    label: Text(
                      'Eliminar Clase',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 93, 255, 142),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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

  // --- FUNCIONALIDAD ---

  /// Genera un código único de 6 caracteres para la clase.
  String _generarCodigoClase() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  /// Permite seleccionar una hora y la asigna al controlador correspondiente.
  Future<void> _seleccionarHora(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horaSeleccionada != null) {
      setState(() {
        final hora = horaSeleccionada.hour.toString().padLeft(2, '0');
        final minuto = horaSeleccionada.minute.toString().padLeft(2, '0');
        controller.text = '$hora:$minuto';
      });
    }
  }

  /// Crea una nueva clase y la guarda en Firestore.
  void _crearClase() async {
    final String nombreClase = nombreClaseController.text.trim();
    final String inicio = inicioClaseController.text.trim();
    final String retardo = retardoController.text.trim();
    final String cierre = cierreQRController.text.trim();

    // Validación de campos vacíos
    if (nombreClase.isEmpty ||
        inicio.isEmpty ||
        retardo.isEmpty ||
        cierre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    final String codigoClase = _generarCodigoClase();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String nombreProfesor =
          prefs.getString('nombreUsuario') ?? 'ProfesorDesconocido';

      // Guardar la clase en Firestore
      await FirebaseFirestore.instance
          .collection('Proyecto')
          .doc(nombreProfesor)
          .collection('clases')
          .doc(codigoClase)
          .set({
        'nombreClase': nombreClase,
        'inicio': inicio,
        'retardo': retardo,
        'cierre': cierre,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clase "$nombreClase" creada con éxito.')),
      );
      await _bajarClasesDeFirestore(); // Recarga la lista desde Firestore
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la clase: $e')),
      );
    }

    // Limpiar los campos
    nombreClaseController.clear();
    inicioClaseController.clear();
    retardoController.clear();
    cierreQRController.clear();
  }

  /// Descarga las clases del profesor desde Firestore y actualiza el historial.
  Future<void> _bajarClasesDeFirestore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String nombreProfesor =
          prefs.getString('nombreUsuario') ?? 'ProfesorDesconocido';

      final clasesRef = FirebaseFirestore.instance
          .collection('Proyecto')
          .doc(nombreProfesor)
          .collection('clases');

      final snapshot = await clasesRef.get();

      List<Map<String, String>> clases = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        clases.add({
          'nombre': data['nombreClase'] ?? doc.id,
          'codigo': doc.id,
          'inicio': data['inicio'] ?? '',
          'retardo': data['retardo'] ?? '',
          'cierre': data['cierre'] ?? '',
        });
      }

      setState(() {
        historialClases.clear();
        historialClases.addAll(clases);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las clases: $e')),
      );
    }
  }

  /// Inscribe al alumno en una clase (no se usa en esta pantalla, pero se deja como referencia).
  void _inscribirAlumno(
      String nombreMateria, String codigoClase, String nombreProfesor) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String nombreAlumno =
          prefs.getString('nombreUsuario') ?? 'AlumnoDesconocido';

      await FirebaseFirestore.instance
          .collection('Proyecto')
          .doc('Usuarios')
          .collection(nombreAlumno)
          .doc(nombreMateria)
          .set({
        'codigoClase': codigoClase,
        'nombreProfesor': nombreProfesor,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Te has inscrito a la clase "$nombreMateria" del profesor "$nombreProfesor".'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al inscribirse a la clase: $e')),
      );
    }
  }

  /// Muestra el formulario para crear una nueva clase.
  void _mostrarFormularioCrearClase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Crear Clase',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreClaseController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nombre de la Clase',
                labelStyle: GoogleFonts.poppins(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF424242),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: inicioClaseController,
              readOnly: true,
              onTap: () => _seleccionarHora(context, inicioClaseController),
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Hora de Inicio',
                labelStyle: GoogleFonts.poppins(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF424242),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: retardoController,
              readOnly: true,
              onTap: () => _seleccionarHora(context, retardoController),
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Hora de Retardo',
                labelStyle: GoogleFonts.poppins(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF424242),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cierreQRController,
              readOnly: true,
              onTap: () => _seleccionarHora(context, cierreQRController),
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Hora de Cierre',
                labelStyle: GoogleFonts.poppins(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF424242),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _crearClase();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  /// Muestra el QR para la clase seleccionada.
  void _mostrarQR() async {
    if (claseSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una clase')),
      );
      return;
    }

    // Buscar la clase seleccionada en el historial
    final clase = historialClases.firstWhere(
      (clase) => clase['codigo'] == claseSeleccionada,
    );

    final String codigoClase = clase['codigo'] ?? '';

    // Validación del código de clase
    final RegExp codigoValido = RegExp(r'^[A-Z0-9]{6}$');
    if (!codigoValido.hasMatch(codigoClase)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El código de la clase no es válido')),
      );
      return;
    }

    // Obtener el nombre del profesor desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String nombreProfesor =
        prefs.getString('nombreUsuario') ?? 'ProfesorDesconocido';

    // Obtener el timestamp actual
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Construir el string para el QR
    final String qrData = '${nombreProfesor}_${codigoClase}_$timestamp';

    // Actualizar el contador Total en la base de datos
    final totalRef = FirebaseFirestore.instance
        .collection('Proyecto')
        .doc(nombreProfesor)
        .collection('clases')
        .doc(codigoClase)
        .collection('alumnos')
        .doc('Total');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(totalRef);
      final current =
          snapshot.exists ? (snapshot.data()?['asistencia'] ?? 0) as int : 0;
      transaction.set(totalRef, {'asistencia': current + 1});
    });

    // Muestra el QR en un diálogo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Código QR generado'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra una lista de todas las clases creadas con su código.
  void _mostrarClasesConCodigo() {
    if (historialClases.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay clases creadas aún')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Clases Creadas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: historialClases.length,
            itemBuilder: (context, index) {
              final clase = historialClases[index];
              return Card(
                color: const Color(0xFF424242),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    'Clase: ${clase['nombre']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Código: ${clase['codigo']}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
