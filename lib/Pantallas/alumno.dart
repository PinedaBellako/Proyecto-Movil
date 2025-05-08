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
                  // Encabezado personalizado con nueva tipografía
                  Text(
                    'Registro de Asistencia',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Tarjeta para los campos de texto
                  Card(
                    color: Colors.white.withOpacity(0.9),
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
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nombreController,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu nombre',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'N# de cuenta:',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: cuentaController,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu número de cuenta',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Botón de escaneo QR en el centro
                  ElevatedButton.icon(
                    onPressed: () async {
                      final qrResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRScanScreen(),
                        ),
                      );

                      if (qrResult != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('QR Escaneado: $qrResult')),
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
                      backgroundColor: const Color(0xFF00796B), // Verde medio
                      foregroundColor: Colors.white,
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
