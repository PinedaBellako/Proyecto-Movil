import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilScreen extends StatelessWidget {
  final String nombreUsuario;
  final String correoUsuario;
  final String rolUsuario; // Ejemplo: "Profesor" o "Alumno"

  const PerfilScreen({
    super.key,
    required this.nombreUsuario,
    required this.correoUsuario,
    required this.rolUsuario,
  });

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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Mueve el contenido hacia arriba
                children: [
                  const SizedBox(height: 50), // Espaciado superior

                  // Imagen de perfil con el nombre del usuario
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      nombreUsuario[0].toUpperCase(), // Inicial del nombre
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nombre del usuario
                  Text(
                    nombreUsuario,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Correo del usuario
                  Text(
                    correoUsuario,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rol del usuario
                  Text(
                    'Rol: $rolUsuario',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para cerrar sesión
                  ElevatedButton.icon(
                    onPressed: () {
                      // Aquí puedes agregar la lógica para cerrar sesión
                      Navigator.pop(context); // Regresar a la pantalla anterior
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Cerrar Sesión',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
