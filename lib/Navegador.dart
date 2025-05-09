import 'package:flutter/material.dart';
import 'package:proyecto/Pantallas/alumno.dart';
import 'package:proyecto/Pantallas/principal.dart';
import 'package:proyecto/Pantallas/profesor.dart';
import 'package:proyecto/Pantallas/registrarse.dart';
import 'package:proyecto/Pantallas/inicio.dart'; // Importa la nueva pantalla

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
    )); // Agrega la nueva pantalla

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
                label: "Inicio", // Nuevo ítem
                icon: Icon(
                  Icons.dashboard,
                )),
          ]),
    );
  }
}
