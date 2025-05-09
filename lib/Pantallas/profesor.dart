import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math'; // Para generar códigos únicos

class profesor extends StatefulWidget {
  const profesor(
      {super.key, required this.title, required this.cambiarPantalla});

  final String title;
  final Function cambiarPantalla;

  @override
  State<profesor> createState() => _profesorState();
}

class _profesorState extends State<profesor> {
  final TextEditingController nombreClaseController = TextEditingController();
  final TextEditingController inicioClaseController = TextEditingController();
  final TextEditingController retardoController = TextEditingController();
  final TextEditingController cierreQRController = TextEditingController();

  // Lista para almacenar el historial de clases
  final List<Map<String, String>> historialClases = [];

  String? claseSeleccionada; // Clase seleccionada para generar QR

  // Generar un código único para la clase
  String _generarCodigoClase() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

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

  void _crearClase() {
    final String nombreClase = nombreClaseController.text.trim();
    final String inicio = inicioClaseController.text.trim();
    final String retardo = retardoController.text.trim();
    final String cierre = cierreQRController.text.trim();

    if (nombreClase.isEmpty ||
        inicio.isEmpty ||
        retardo.isEmpty ||
        cierre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Generar un código único para la clase
    final String codigoClase = _generarCodigoClase();

    // Guardar la clase en el historial
    setState(() {
      historialClases.add({
        'nombre': nombreClase,
        'inicio': inicio,
        'retardo': retardo,
        'cierre': cierre,
        'codigo': codigoClase,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Clase "$nombreClase" creada con éxito. Código: $codigoClase')),
    );

    // Limpiar los campos
    nombreClaseController.clear();
    inicioClaseController.clear();
    retardoController.clear();
    cierreQRController.clear();
  }

  void _mostrarFormularioCrearClase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C), // Fondo gris carbón
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
                fillColor: const Color(0xFF424242), // Gris más claro
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
              Navigator.pop(context); // Cerrar el formulario
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _crearClase();
              Navigator.pop(
                  context); // Cerrar el formulario después de crear la clase
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

  void _mostrarQR() {
    if (claseSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una clase')),
      );
      return;
    }

    // Buscar la clase seleccionada en el historial
    final clase = historialClases.firstWhere(
      (clase) => clase['nombre'] == claseSeleccionada,
    );

    // Mostrar el QR con el código único de la clase
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Código QR generado'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: QrImageView(
            data: 'Código de Clase: ${clase['codigo']}', // Contenido del QR
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
        backgroundColor: const Color(0xFF2C2C2C), // Fondo gris carbón
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
                color: const Color(0xFF424242), // Fondo gris más claro
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
              Navigator.pop(context); // Cerrar el diálogo
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

                  // Botón para abrir el formulario de crear clase
                  ElevatedButton.icon(
                    onPressed: _mostrarFormularioCrearClase,
                    icon: const Icon(Icons.add, size: 30),
                    label: Text(
                      'Crear Clase',
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

                  // Dropdown para seleccionar clase
                  Card(
                    color: const Color(0xFF2C2C2C), // Fondo gris carbón
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
                                value: clase['nombre'],
                                child: Text(
                                  clase['nombre']!,
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

                  // Botón para generar QR
                  ElevatedButton.icon(
                    onPressed: _mostrarQR,
                    icon: const Icon(Icons.qr_code, size: 30),
                    label: Text(
                      'Generar QR',
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

                  // Botón para mostrar clases con código
                  ElevatedButton.icon(
                    onPressed: _mostrarClasesConCodigo,
                    icon: const Icon(Icons.list, size: 30),
                    label: Text(
                      'Ver Clases',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
