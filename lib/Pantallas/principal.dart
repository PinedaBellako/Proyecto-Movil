import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class principal extends StatefulWidget {
  const principal(
      {super.key, required this.title, required this.cambiarPantalla});

  final String title;
  final Function cambiarPantalla;

  @override
  State<principal> createState() => _principalState();
}

class _principalState extends State<principal> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  void leerDeLaBD() async {
    String usuario = usuarioController.text.trim();
    String contrasena = contrasenaController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Llena ambos campos')),
      );
      return;
    }

    try {
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

      final data = doc.data()!;

      if (data['contraseña'] == contrasena) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Acceso concedido')),
        );

        // Redirigir según el tipo de usuario
        if (data['tipo'] == 'alumno') {
          widget.cambiarPantalla(2);
        } else {
          widget.cambiarPantalla(3);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña incorrecta')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al leer la base de datos: $e')),
      );
    }
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
                  Color.fromARGB(255, 76, 163, 97), // Verde oscuro
                  Color.fromARGB(255, 9, 15, 9), // Negro
                ],
                stops: [
                  0.0,
                  0.5
                ], // Ajusta el punto de transición del degradado
              ),
            ),
          ),
          // Contenido principal
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Título
                    Text(
                      'Bienvenido',
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
                    // Campo de contraseña
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
                    // Botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: leerDeLaBD,
                          icon: const Icon(Icons.login),
                          label: Text(
                            'Acceder',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(
                                255, 93, 255, 142), // Verde medio
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.cambiarPantalla(1);
                          },
                          icon: const Icon(Icons.person_add),
                          label: Text(
                            'Registrarse',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(
                                255, 93, 255, 142), // Verde medio
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
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
}
