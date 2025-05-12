import 'package:flutter/material.dart';
import 'package:proyecto/Pantallas/alumno.dart';
import 'package:proyecto/Pantallas/principal.dart';
import 'package:proyecto/Pantallas/profesor.dart';
import 'package:proyecto/Pantallas/registrarse.dart';
import 'package:proyecto/Pantallas/inicio.dart';
import 'package:proyecto/Pantallas/perfil.dart';
import 'package:proyecto/Pantallas/actividad.dart'; // Importa la pantalla de actividad
import 'package:proyecto/Pantallas/Actprofesor.dart'; // Importa la pantalla de ActProfesorScreen

class Navegador extends StatefulWidget {
  const Navegador({super.key});
  @override
  State<Navegador> createState() => _NavegadorState();
}

class _NavegadorState extends State<Navegador> {
  Widget? _cuerpo;
  final List<Widget> _pantallas = [];
  int _p = 0;

  void _cambiaPantalla(int v) {
    setState(() {
      _p = v;
      _cuerpo = _pantallas[_p];
    });
  }

  @override
  void initState() {
    super.initState();
    _pantallas.add(
        principal(title: "Iniciar sesion", cambiarPantalla: _cambiaPantalla));
    _pantallas
        .add(registrarse(title: 'LogIn', cambiarPantalla: _cambiaPantalla));
    _pantallas
        .add(alumno(title: 'Pase de Lista?', cambiarPantalla: _cambiaPantalla));
    _pantallas
        .add(profesor(title: 'Pasar lista', cambiarPantalla: _cambiaPantalla));
    _pantallas.add(InicioScreen(
      nombreUsuario: 'Alumno',
      esProfesor: false,
      cambiarPantalla: _cambiaPantalla,
    ));
    _pantallas.add(PerfilScreen(
      nombreUsuario: 'KEVIN',
      correoUsuario: 'kevin@example.com',
      rolUsuario: 'Profesor',
    ));
    _pantallas.add(const ActividadScreen()); // Agrega la pantalla de actividad
    _pantallas.add(const ActProfesorScreen());
    _cuerpo = _pantallas[_p];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cuerpo,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _p,
          onTap: (value) => _cambiaPantalla(value),
          backgroundColor: const Color.fromARGB(255, 15, 20, 15), // Verde medio
          selectedItemColor:
              Color.fromARGB(255, 93, 255, 142), // Color del ítem seleccionado
          unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                label: "Principal",
                icon: Icon(
                  Icons.home,
                )),
            BottomNavigationBarItem(
                label: "Login",
                icon: Icon(
                  Icons.login,
                )),
            BottomNavigationBarItem(
                label: "Alumno",
                icon: Icon(
                  Icons.school,
                )),
            BottomNavigationBarItem(
                label: "Profesor",
                icon: Icon(
                  Icons.person,
                )),
            BottomNavigationBarItem(
                label: "Inicio",
                icon: Icon(
                  Icons.dashboard,
                )),
            BottomNavigationBarItem(
                label: "Perfil",
                icon: Icon(
                  Icons.account_circle,
                )),
            BottomNavigationBarItem(
                label: "Actividad", // Nuevo ítem
                icon: Icon(
                  Icons.calendar_today,
                )),
            BottomNavigationBarItem(
                label: "Act. Profesor", icon: Icon(Icons.assignment)),
          ]),
    );
  }
}
