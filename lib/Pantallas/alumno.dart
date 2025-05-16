import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Pantalla principal para alumnos.
/// Permite seleccionar una clase, ver su nombre y registrar asistencia escaneando un QR.
class alumno extends StatefulWidget {
  const alumno({super.key, required this.title, required this.cambiarPantalla});

  final String title;
  final Function cambiarPantalla;

  @override
  State<alumno> createState() => _alumnoState();
}

class _alumnoState extends State<alumno> {
  // --- FORMATO Y ESTILOS ---
  final Color colorFondoInicio = const Color.fromARGB(255, 76, 163, 97);
  final Color colorFondoFin = const Color(0xFF000000);
  final Color colorCard = const Color(0xFF2C2C2C);
  final Color colorCardFill = const Color(0xFF424242);
  final Color colorTitulo = Colors.white;
  final Color colorSubtitulo = Colors.white;
  final Color colorTexto = Colors.white70;
  final Color colorBoton = const Color.fromARGB(255, 93, 255, 142);
  final Color colorBotonTexto = Colors.black;
  final double tamanoTitulo = 28.0;
  final double tamanoSubtitulo = 18.0;
  final double tamanoTexto = 16.0;
  final double radioBorde = 15.0;

  final TextEditingController nombreController = TextEditingController();
  String? claseSeleccionada;
  List<String> clasesInscritas = [];

  // --- WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título principal
                  Text(
                    'Registro de Asistencia',
                    style: GoogleFonts.poppins(
                      fontSize: tamanoTitulo,
                      color: colorTitulo,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Catálogo de clases inscritas (dropdown)
                  Card(
                    color: colorCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radioBorde),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selecciona tu clase:',
                            style: GoogleFonts.poppins(
                              fontSize: tamanoSubtitulo,
                              color: colorSubtitulo,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: claseSeleccionada,
                            items: clasesInscritas.map((String clase) {
                              return DropdownMenuItem<String>(
                                value: clase,
                                child: Text(
                                  clase,
                                  style: GoogleFonts.poppins(
                                    fontSize: tamanoTexto,
                                    color: Colors.white,
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
                              fillColor: colorCardFill,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                            dropdownColor: colorCard,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tarjeta para mostrar el nombre del usuario (solo lectura)
                  Card(
                    color: colorCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radioBorde),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre:',
                            style: GoogleFonts.poppins(
                              fontSize: tamanoSubtitulo,
                              color: colorSubtitulo.withAlpha(221),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nombreController,
                            readOnly: true, // Solo lectura
                            decoration: InputDecoration(
                              hintText: 'Nombre de usuario',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: tamanoTexto,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: colorCardFill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para escanear QR y registrar asistencia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (claseSeleccionada == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Por favor, selecciona una clase'),
                              ),
                            );
                            return;
                          }

                          // Navega a la pantalla de escaneo QR y espera el resultado
                          final qrResult = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRScanScreen(),
                            ),
                          );

                          // Si se obtuvo un resultado, intenta registrar la asistencia
                          if (qrResult != null) {
                            await registrarAsistenciaDesdeQR(qrResult);
                          }
                        },
                        icon: const Icon(Icons.qr_code_scanner, size: 30),
                        label: Text(
                          'Escanear QR',
                          style: GoogleFonts.poppins(
                            fontSize: tamanoSubtitulo,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorBoton,
                          foregroundColor: colorBotonTexto,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Texto de ayuda
                  Text(
                    'Escanea el código QR para registrar tu asistencia',
                    style: GoogleFonts.poppins(
                      fontSize: tamanoTexto,
                      color: colorTexto,
                    ),
                    textAlign: TextAlign.center,
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
    cargarClasesInscritas();
    cargarNombreUsuario();
  }

  /// Carga el nombre del usuario desde SharedPreferences y lo muestra en el campo correspondiente.
  Future<void> cargarNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final String nombreUsuario = prefs.getString('nombreUsuario') ?? '';
    setState(() {
      nombreController.text = nombreUsuario;
    });
  }

  /// Carga las clases inscritas del usuario desde Firestore.
  /// Actualiza el dropdown de clases.
  Future<void> cargarClasesInscritas() async {
    final prefs = await SharedPreferences.getInstance();
    final String usuario = prefs.getString('usuario') ?? '';

    final materiasSnapshot = await FirebaseFirestore.instance
        .collection('Proyecto')
        .doc('Usuarios')
        .collection(usuario)
        .get();

    // Omite el documento llamado 'datos'
    final clases = materiasSnapshot.docs
        .where((doc) => doc.id.trim().toLowerCase() != 'datos')
        .map((doc) => doc.id)
        .toList();

    setState(() {
      clasesInscritas = clases;
      if (clasesInscritas.isNotEmpty) {
        claseSeleccionada = clasesInscritas.first;
      }
    });
  }

  /// Procesa el resultado del QR escaneado y registra la asistencia o retardo.
  /// Valida el QR, verifica la clase y actualiza los datos en Firestore.
  Future<void> registrarAsistenciaDesdeQR(String qrResult) async {
    // El QR tiene formato: nombreProfesor_codigoClase_timestamp
    final primerGuion = qrResult.indexOf('_');
    final segundoGuion = qrResult.indexOf('_', primerGuion + 1);

    if (primerGuion == -1 || segundoGuion == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR inválido')),
      );
      return;
    }

    final nombreProfesor = qrResult.substring(0, primerGuion);
    final codigoClaseQR = qrResult.substring(primerGuion + 1, segundoGuion);
    final timestamp = qrResult.substring(segundoGuion + 1);

    final prefs = await SharedPreferences.getInstance();
    final String usuario = prefs.getString('usuario') ?? '';

    // 1. Obtener el campo 'codigo' de la clase seleccionada
    final claseSeleccionadaDoc = await FirebaseFirestore.instance
        .collection('Proyecto')
        .doc('Usuarios')
        .collection(usuario)
        .doc(claseSeleccionada)
        .get();

    if (!claseSeleccionadaDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clase seleccionada no encontrada')),
      );
      return;
    }

    final codigoClaseAlumno = claseSeleccionadaDoc.data()?['codigo'];
    if (codigoClaseAlumno == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La clase seleccionada no tiene código')),
      );
      return;
    }

    // 2. Comparar el código de la clase seleccionada con el del QR
    if (codigoClaseAlumno != codigoClaseQR) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El QR no corresponde a la clase seleccionada')),
      );
      return;
    }

    // 3. Registrar asistencia o retardo según la hora
    final claseDoc = await FirebaseFirestore.instance
        .collection('Proyecto')
        .doc(nombreProfesor)
        .collection('clases')
        .doc(codigoClaseQR)
        .get();

    if (!claseDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clase no encontrada')),
      );
      return;
    }

    final data = claseDoc.data()!;

    // Espera que los campos sean tipo "HH:mm", por ejemplo: "08:00"
    String inicioStr = data['inicio'] ?? '00:00';
    String retardoStr = data['retardo'] ?? '00:00';
    String cierreStr = data['cierre'] ?? '00:00';

    // Función para convertir "HH:mm" a DateTime de hoy
    DateTime parseHora(String? hora) {
      if (hora == null || hora.isEmpty) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, 0, 0);
      }
      final partes = hora.split(':');
      if (partes.length != 2) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, 0, 0);
      }
      int horaInt = 0;
      int minutoInt = 0;
      try {
        horaInt = int.parse(partes[0]);
        minutoInt = int.parse(partes[1]);
      } catch (e) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, 0, 0);
      }
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, horaInt, minutoInt);
    }

    final inicio = parseHora(inicioStr).millisecondsSinceEpoch;
    final retardo = parseHora(retardoStr).millisecondsSinceEpoch;
    final cierre = parseHora(cierreStr).millisecondsSinceEpoch;

    final now = DateTime.now().millisecondsSinceEpoch;
    String? tipo;

    if (now >= inicio && now < retardo) {
      tipo = 'asistencias';
    } else if (now >= retardo && now < cierre) {
      tipo = 'retardos';
    } else {
      tipo = null;
    }

    if (tipo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro fuera de tiempo')),
      );
      return;
    }

    // Obtén el nombreUsuario de SharedPreferences
    final String nombreUsuario = prefs.getString('nombreUsuario') ?? '';

    // Referencia al documento correcto usando nombreUsuario
    final alumnoRef = FirebaseFirestore.instance
        .collection('Proyecto')
        .doc(nombreProfesor)
        .collection('clases')
        .doc(codigoClaseQR)
        .collection('alumnos')
        .doc(nombreUsuario);

    final alumnoSnapshot = await alumnoRef.get();

    // Validar si ya escaneó el QR de hoy (o el mismo timestamp)
    if (alumnoSnapshot.exists) {
      final datosAlumno = alumnoSnapshot.data()!;
      if (datosAlumno['timestamp'] == timestamp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ya registraste tu asistencia con este QR')),
        );
        return;
      }
    }

    // Si no ha escaneado este QR, registra la asistencia o retardo
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(alumnoRef);
      final datosAlumno = snapshot.data() ?? {};

      int asistencias = datosAlumno['asistencias'] ?? 0;
      int retardos = datosAlumno['retardos'] ?? 0;

      if (tipo == 'asistencias') {
        asistencias += 1;
      } else {
        retardos += 1;
      }

      transaction.set(alumnoRef, {
        'asistencias': asistencias,
        'retardos': retardos,
        'nombre': nombreUsuario,
        'timestamp': timestamp,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('¡$tipo registrada!')),
    );
  }
}

// --- WIDGET PARA ESCANEAR QR ---
class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: const Color(0xFF00796B),
      ),
      // Widget de escaneo QR usando mobile_scanner
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return;
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              setState(() => _isProcessing = true);
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
