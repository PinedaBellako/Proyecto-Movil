import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pantalla de perfil del usuario, muestra nombre, rol y permite cerrar sesión
class PerfilScreen extends StatelessWidget {
  final String nombreUsuario;
  final String rolUsuario; // Ejemplo: "Profesor" o "Alumno"

  const PerfilScreen({
    super.key,
    required this.nombreUsuario,
    required this.rolUsuario,
  });

  @override
  Widget build(BuildContext context) {
    // --- DISEÑO Y WIDGETS ---
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con degradado verde a negro
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
          // Contenido principal centrado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50), // Espacio arriba

                  // Avatar circular con la inicial del usuario
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      (nombreUsuario.isNotEmpty
                          ? nombreUsuario[0].toUpperCase()
                          : '?'), // Muestra la inicial o un signo de interrogación
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nombre completo del usuario o mensaje si no hay nombre
                  Text(
                    nombreUsuario.isNotEmpty
                        ? nombreUsuario
                        : 'Usuario desconocido',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rol del usuario o mensaje si no hay rol
                  Text(
                    rolUsuario.isNotEmpty
                        ? 'Rol: $rolUsuario'
                        : 'Rol: Desconocido',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para cerrar sesión
                  ElevatedButton.icon(
                    onPressed: () => _cerrarSesion(context),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Cerrar Sesión',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 93, 255, 142),
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

  // --- FUNCIONALIDAD ---
  // Esta función limpia los datos de sesión guardados y regresa al inicio
  Future<void> _cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombreUsuario', 'Usuario'); // Reinicia nombre
    await prefs.setString('rolUsuario', ''); // Borra el rol
    await prefs.setString('Usuario', ''); // Borra el usuario
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
