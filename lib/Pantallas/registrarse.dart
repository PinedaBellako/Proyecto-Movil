import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Pantalla de registro de usuario.
/// Permite crear una cuenta nueva como alumno o profesor.
class registrarse extends StatefulWidget {
  const registrarse({
    super.key,
    required this.title,
    required this.cambiarPantalla,
  });

  final Function cambiarPantalla;
  final String title;

  @override
  State<registrarse> createState() => _registrarseState();
}

class _registrarseState extends State<registrarse> {
  // Controla si el usuario es alumno o profesor
  bool _eresAlumno = true;

  // Controladores para los campos de texto
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController repetirController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // --- DISEÑO Y WIDGETS ---
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
                  Color.fromARGB(255, 76, 163, 97), // Verde oscuro
                  Color.fromARGB(255, 9, 15, 9), // Negro
                ],
              ),
            ),
          ),
          // Contenido principal centrado
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Título de la pantalla
                    Text(
                      'Crear Cuenta',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Campo de usuario
                    Text(
                      'Ingresa tu usuario:',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _campoTexto(
                      controller: usuarioController,
                      hint: 'Usuario',
                    ),
                    const SizedBox(height: 20),

                    // Campo de contraseña
                    Text(
                      'Ingresa tu contraseña:',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _campoTexto(
                      controller: contrasenaController,
                      hint: 'Contraseña',
                      esContrasena: true,
                    ),
                    const SizedBox(height: 20),

                    // Campo para repetir contraseña
                    Text(
                      'Repite tu contraseña:',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _campoTexto(
                      controller: repetirController,
                      hint: 'Repite tu contraseña',
                      esContrasena: true,
                    ),
                    const SizedBox(height: 20),

                    // Campo de nombre completo
                    Text(
                      'Ingresa tu nombre:',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _campoTexto(
                      controller: nombreController,
                      hint: 'Nombre completo',
                    ),
                    const SizedBox(height: 20),

                    // Checkbox para seleccionar si es alumno
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _eresAlumno,
                          onChanged: preguntaAlumnos,
                          activeColor: const Color.fromARGB(255, 93, 255, 142),
                        ),
                        Text(
                          '¿Eres alumno?',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Botones de crear cuenta y regresar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: cargarALaBD,
                          icon: const Icon(Icons.person_add, size: 20),
                          label: Text(
                            'Crear cuenta',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 93, 255, 142),
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => widget.cambiarPantalla(0),
                          icon: const Icon(Icons.arrow_back, size: 20),
                          label: Text(
                            'Regresar',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 93, 255, 142),
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- FUNCIONALIDAD ---

  /// Actualiza el estado del checkbox para saber si el usuario es alumno.
  void preguntaAlumnos(bool? value) {
    setState(() {
      _eresAlumno = value ?? true;
    });
  }

  /// Intenta registrar al usuario en Firestore.
  /// Valida los campos, verifica que el usuario no exista y guarda los datos.
  void cargarALaBD() async {
    String usuario = usuarioController.text.trim();
    String contrasena = contrasenaController.text.trim();
    String repetir = repetirController.text.trim();
    String nombre = nombreController.text.trim();

    // Validación de campos vacíos
    if (usuario.isEmpty ||
        contrasena.isEmpty ||
        repetir.isEmpty ||
        nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    // Validación de contraseñas iguales
    if (contrasena != repetir) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    try {
      // Referencia al documento de datos del usuario
      final datosRef = FirebaseFirestore.instance
          .collection('Proyecto')
          .doc('Usuarios')
          .collection(usuario)
          .doc('Datos');

      // Verifica si el usuario ya existe
      final snapshot = await datosRef.get();

      if (snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El usuario ya existe')),
        );
        return;
      }

      // Guarda los datos del usuario en Firestore
      await datosRef.set({
        'usuario': usuario,
        'contraseña': contrasena,
        'nombre': nombre,
        'tipo': _eresAlumno ? 'alumno' : 'profesor',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada correctamente')),
      );

      // Regresa a la pantalla principal de login
      widget.cambiarPantalla(0);
    } catch (e) {
      final mensaje = e.toString();
      print(" ERROR AL REGISTRAR: $mensaje");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $mensaje')),
      );
    }
  }

  /// Widget reutilizable para los campos de texto del formulario.
  Widget _campoTexto({
    required TextEditingController controller,
    required String hint,
    bool esContrasena = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: esContrasena,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
