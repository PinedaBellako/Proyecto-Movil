import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Navegador.dart';

/// Pantalla principal de inicio de sesión.
/// Permite al usuario ingresar sus credenciales, iniciar sesión, registrarse o recuperar su contraseña.
class principal extends StatefulWidget {
  const principal({
    super.key,
    required this.title,
    required this.cambiarPantalla,
  });

  final String title;
  final Function cambiarPantalla;

  @override
  State<principal> createState() => _principalState();
}

class _principalState extends State<principal> {
  // Controladores para los campos de usuario y contraseña
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

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
                  Color.fromARGB(255, 76, 163, 97),
                  Color.fromARGB(255, 9, 15, 9),
                ],
              ),
            ),
          ),
          // Contenido principal centrado y desplazable
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Título de bienvenida
                    Text(
                      'Bienvenido',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Etiqueta y campo de usuario
                    Text(
                      'Ingresa tu usuario:',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                        controller: usuarioController,
                        decoration: InputDecoration(
                          hintText: 'Usuario',
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
                    ),
                    const SizedBox(height: 20),
                    // Etiqueta y campo de contraseña
                    Text(
                      'Ingresa tu contraseña:',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                        controller: contrasenaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
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
                    ),
                    const SizedBox(height: 30),
                    // Botones de acceso y registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botón para iniciar sesión
                        ElevatedButton.icon(
                          onPressed: leerDeLaBD,
                          icon: const Icon(Icons.login, size: 20),
                          label: Text(
                            'Acceder',
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
                        // Botón para ir a la pantalla de registro
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.cambiarPantalla(1);
                          },
                          icon: const Icon(Icons.person_add, size: 20),
                          label: Text(
                            'Registrarse',
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
                    const SizedBox(height: 10),
                    // Botón para recuperar contraseña
                    TextButton(
                      onPressed: () => _mostrarDialogoRecuperar(context),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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

  /// Guarda los datos del usuario en SharedPreferences para mantener la sesión.
  Future<void> _guardarDatosUsuario(
      String usuario, String nombre, String tipo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', usuario);
    await prefs.setString('nombreUsuario', nombre);
    await prefs.setString('rolUsuario', tipo);
  }

  /// Valida usuario y contraseña en Firestore.
  /// Si son correctos, guarda los datos y navega a la pantalla principal.
  /// Si hay error, muestra un mensaje correspondiente.
  void leerDeLaBD() async {
    String usuario = usuarioController.text.trim();
    String contrasena = contrasenaController.text.trim();

    // Validación de campos vacíos
    if (usuario.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Llena ambos campos')),
      );
      return;
    }

    try {
      // Consulta a Firestore para obtener los datos del usuario
      final doc = await FirebaseFirestore.instance
          .collection('Proyecto')
          .doc('Usuarios')
          .collection(usuario)
          .doc('Datos')
          .get();

      // Si el usuario no existe
      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no encontrado')),
        );
        return;
      }

      final data = doc.data()!;

      // Verifica la contraseña
      if (data['contraseña'] == contrasena) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Acceso concedido')),
        );

        String nombre = data['nombre'];
        String tipo = data['tipo'];

        await _guardarDatosUsuario(usuario, nombre, tipo);

        // Navega a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Navegador()),
        );
      } else {
        // Contraseña incorrecta
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña incorrecta')),
        );
      }
    } catch (e) {
      // Error de conexión o consulta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al leer la base de datos: $e')),
      );
    }
  }

  /// Muestra un diálogo para recuperar la contraseña.
  /// El usuario debe ingresar su usuario, nombre y la nueva contraseña.
  /// Si los datos coinciden, se actualiza la contraseña en Firestore.
  void _mostrarDialogoRecuperar(BuildContext context) {
    final TextEditingController usuarioRecController = TextEditingController();
    final TextEditingController nombreRecController = TextEditingController();
    final TextEditingController nuevaContraController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Recuperar contraseña',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo para usuario
              TextField(
                controller: usuarioRecController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF424242),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Campo para nombre
              TextField(
                controller: nombreRecController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF424242),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Campo para nueva contraseña
              TextField(
                controller: nuevaContraController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  labelStyle: const TextStyle(color: Colors.white),
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
            // Botón para cancelar el diálogo
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            // Botón para recuperar la contraseña
            ElevatedButton(
              onPressed: () async {
                final usuario = usuarioRecController.text.trim();
                final nombre = nombreRecController.text.trim();
                final nuevaContra = nuevaContraController.text.trim();
                if (usuario.isEmpty || nombre.isEmpty || nuevaContra.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos')),
                  );
                  return;
                }
                try {
                  // Consulta a Firestore para validar usuario y nombre
                  final doc = await FirebaseFirestore.instance
                      .collection('Proyecto')
                      .doc('Usuarios')
                      .collection(usuario)
                      .doc('Datos')
                      .get();

                  if (!doc.exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario no encontrado')),
                    );
                    return;
                  }

                  final data = doc.data();
                  if (data?['nombre'] != nombre) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Usuario o nombre incorrecto')),
                    );
                    return;
                  }

                  // Actualiza la contraseña en Firestore
                  await FirebaseFirestore.instance
                      .collection('Proyecto')
                      .doc('Usuarios')
                      .collection(usuario)
                      .doc('Datos')
                      .update({'contraseña': nuevaContra});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Contraseña actualizada correctamente')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error al actualizar la contraseña: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 93, 255, 142),
                foregroundColor: Colors.black,
              ),
              child: const Text('Recuperar'),
            ),
          ],
        );
      },
    );
  }
}
