import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InicioScreen extends StatelessWidget {
  final String nombreUsuario;
  final bool esProfesor;
  final Function cambiarPantalla; // Método para cambiar de pantalla

  const InicioScreen({
    super.key,
    required this.nombreUsuario,
    required this.esProfesor,
    required this.cambiarPantalla, // Recibe el método cambiarPantalla
  });

  void _mostrarFormularioUnirseClase(BuildContext context) {
    final TextEditingController codigoClaseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C), // Fondo gris carbón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Unirse a una Clase',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white, // Letras blancas
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codigoClaseController,
              style: GoogleFonts.poppins(color: Colors.white), // Texto blanco
              decoration: InputDecoration(
                labelText: 'Código de Clase',
                labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white, // Letras blancas
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: const Color(0xFF424242), // Fondo gris más claro
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el formulario
            },
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: Colors.white), // Letras blancas
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final String codigoClase = codigoClaseController.text.trim();

              if (codigoClase.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, ingresa un código'),
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Te has unido a la clase: $codigoClase'),
                ),
              );

              Navigator.pop(context); // Cerrar el formulario después de unirse
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B), // Verde medio
              foregroundColor: Colors.white,
            ),
            child: const Text('Unirse'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido, $nombreUsuario', // Mensaje de bienvenida dinámico
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white, // Texto en blanco
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 27, 19), // Verde medio
      ),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Sección de Acciones Rápidas
                  Text(
                    'Acciones Rápidas',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white, // Sin negritas
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Distribución uniforme
                    children: [
                      // Botón Registrar Asistencia
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cambiarPantalla(
                                2); // Redirige a la pantalla de alumno
                          },
                          icon: const Icon(Icons.check_circle, size: 30),
                          label: Text(
                            'Registrar Asistencia',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF2C2C2C), // Gris carbón
                            foregroundColor: Colors.white,
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
                      const SizedBox(width: 10), // Espaciado entre botones
                      // Botón Unirme a una Clase
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _mostrarFormularioUnirseClase(
                                context); // Mostrar formulario
                          },
                          icon: const Icon(Icons.group_add, size: 30),
                          label: Text(
                            'Unirme a una Clase',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF2C2C2C), // Gris carbón
                            foregroundColor: Colors.white,
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

                  // Botón Crear QR (Solo para Profesores)
                  if (esProfesor)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Acción para generar QR
                      },
                      icon: const Icon(Icons.qr_code, size: 30),
                      label: Text(
                        'Crear QR',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2C), // Gris carbón
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),

                  // Calendario de Asistencia
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C), // Gris carbón
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calendario de Asistencia',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white, // Sin negritas
                          ),
                        ),
                        const SizedBox(height: 10),
                        CalendarWidget(),
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
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final Map<String, bool> attendance = {
    'Lun': true,
    'Mar': false,
    'Mié': true,
    'Jue': false,
    'Vie': true,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: attendance.keys.map((day) {
        return GestureDetector(
          onTap: () {
            setState(() {
              attendance[day] = !(attendance[day] ?? false);
            });
          },
          child: Column(
            children: [
              Text(
                day,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Icon(
                attendance[day]! ? Icons.check_circle : Icons.cancel,
                color: attendance[day]! ? Colors.green : Colors.red,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
