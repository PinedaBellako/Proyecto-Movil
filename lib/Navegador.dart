import 'package:flutter/material.dart';
import 'package:proyecto/Pantallas/alumno.dart';
import 'package:proyecto/Pantallas/principal.dart';
import 'package:proyecto/Pantallas/profesor.dart';
import 'package:proyecto/Pantallas/registrarse.dart';

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
                label: "principal",
                icon: Icon(
                  Icons.accessibility_sharp,
                )),
            BottomNavigationBarItem(
                label: "Login",
                icon: Icon(
                  Icons.accessibility_sharp,
                )),
            BottomNavigationBarItem(
                label: "Alumno",
                icon: Icon(
                  Icons.accessibility_sharp,
                )),
            BottomNavigationBarItem(
                label: "Porfesor",
                icon: Icon(
                  Icons.accessibility_sharp,
                )),
          ]),
    );
  }
}
