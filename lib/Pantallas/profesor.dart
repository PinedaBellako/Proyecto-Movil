import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class profesor extends StatefulWidget {
  const profesor(
      {super.key, required this.title, required this.cambiarPantalla});

  final String title;
  final Function cambiarPantalla;

  @override
  State<profesor> createState() => _profesorState();
}

class _profesorState extends State<profesor> {
  final TextEditingController inicioClaseController = TextEditingController();
  final TextEditingController retardoController = TextEditingController();
  final TextEditingController cierreQRController = TextEditingController();

  // Lista para almacenar el historial de clases
  final List<Map<String, String>> historialClases = [];

  Future<void> _seleccionarHora(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horaSeleccionada != null) {
      setState(() {
        controller.text =
            horaSeleccionada.format(context); // Formatea la hora seleccionada
      });
    }
  }

  void _mostrarQR() {
    if (inicioClaseController.text.isEmpty ||
        retardoController.text.isEmpty ||
        cierreQRController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Guardar la configuración en el historial
    setState(() {
      historialClases.add({
        'inicio': inicioClaseController.text,
        'retardo': retardoController.text,
        'cierre': cierreQRController.text,
      });
    });

    // Mostrar el QR
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Código QR generado'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: QrImageView(
            data: 'Inicio: ${inicioClaseController.text}, '
                'Retardo: ${retardoController.text}, '
                'Cierre: ${cierreQRController.text}',
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
                    'Configuración de Clase',
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
                            'Hora de inicio de la clase:',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: inicioClaseController,
                            readOnly: true,
                            onTap: () => _seleccionarHora(
                                context, inicioClaseController),
                            decoration: InputDecoration(
                              hintText: 'Selecciona la hora de inicio',
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
                            'Hora de retardo:',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: retardoController,
                            readOnly: true,
                            onTap: () =>
                                _seleccionarHora(context, retardoController),
                            decoration: InputDecoration(
                              hintText: 'Selecciona la hora de retardo',
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
                            'Hora de cierre del QR:',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: cierreQRController,
                            readOnly: true,
                            onTap: () =>
                                _seleccionarHora(context, cierreQRController),
                            decoration: InputDecoration(
                              hintText: 'Selecciona la hora de cierre',
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
                  // Botón para crear QR
                  ElevatedButton.icon(
                    onPressed: _mostrarQR,
                    icon: const Icon(Icons.qr_code, size: 30),
                    label: Text(
                      'Crear QR',
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
                  const SizedBox(height: 30),
                  // Historial de clases
                  Text(
                    'Historial de Clases',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historialClases.length,
                    itemBuilder: (context, index) {
                      final clase = historialClases[index];
                      return Card(
                        child: ListTile(
                          title: Text('Inicio: ${clase['inicio']}'),
                          subtitle: Text('Cierre: ${clase['cierre']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.qr_code),
                            onPressed: () {
                              // Mostrar el QR nuevamente
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Código QR generado'),
                                  content: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: QrImageView(
                                      data: 'Inicio: ${clase['inicio']}, '
                                          'Retardo: ${clase['retardo']}, '
                                          'Cierre: ${clase['cierre']}',
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
                            },
                          ),
                        ),
                      );
                    },
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
