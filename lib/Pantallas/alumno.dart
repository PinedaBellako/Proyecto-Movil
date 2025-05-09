import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class alumno extends StatefulWidget {
  const alumno({super.key, required this.title, required this.cambiarPantalla});

  final String title;
  final Function cambiarPantalla;

  @override
  State<alumno> createState() => _alumnoState();
}

class _alumnoState extends State<alumno> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cuentaController = TextEditingController();

  // Lista de clases inscritas (puedes reemplazar esto con datos dinámicos de Firebase)
  final List<String> clasesInscritas = [
    'Matemáticas',
    'Historia',
    'Ciencias',
    'Inglés',
    'Programación',
  ];

  String? claseSeleccionada; // Clase seleccionada por el alumno

  @override
  Widget build(BuildContext context) {
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
                  Color(0xFF004D40), // Verde oscuro
                  Color(0xFF000000), // Negro
                ],
              ),
            ),
          ),
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Encabezado personalizado
                  Text(
                    'Registro de Asistencia',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Catálogo de clases inscritas
                  Card(
                    color: const Color(0xFF2C2C2C), // Fondo gris carbón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
                              fontSize: 18,
                              color: Colors.white,
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
                              fillColor:
                                  const Color(0xFF424242), // Gris más claro
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                            dropdownColor:
                                Colors.grey[200], // Fondo del menú desplegable
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tarjeta para los campos de texto
                  Card(
                    color: const Color(0xFF2C2C2C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
                              fontSize: 18,
                              color: const Color.fromARGB(221, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nombreController,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu nombre',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Color(0xFF424242),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'N# de cuenta:',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: const Color.fromARGB(221, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: cuentaController,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu número de cuenta',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Color(0xFF424242),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón de escaneo QR
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (claseSeleccionada == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, selecciona una clase'),
                          ),
                        );
                        return;
                      }

                      final qrResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRScanScreen(),
                        ),
                      );

                      if (qrResult != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Asistencia registrada en $claseSeleccionada: $qrResult',
                            ),
                          ),
                        );

                        // Aquí puedes procesar los datos del QR
                        print('Datos del QR: $qrResult');
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 30),
                    label: Text(
                      'Escanear QR',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 93, 255, 142), // Verde medio
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Texto adicional
                  Text(
                    'Escanea el código QR para registrar tu asistencia',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
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
}

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: const Color(0xFF00796B), // Verde medio
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera(); // Pausa la cámara después de escanear
      Navigator.pop(context, scanData.code); // Devuelve el resultado del QR
    });
  }
}
