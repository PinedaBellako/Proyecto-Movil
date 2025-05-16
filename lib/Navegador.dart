import 'package:flutter/material.dart';
import 'package:proyecto/Pantallas/alumno.dart';
import 'package:proyecto/Pantallas/principal.dart';
import 'package:proyecto/Pantallas/profesor.dart';
import 'package:proyecto/Pantallas/registrarse.dart';
import 'package:proyecto/Pantallas/inicio.dart';
import 'package:proyecto/Pantallas/perfil.dart';
import 'package:proyecto/Pantallas/Actprofesor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navegador extends StatefulWidget {
  const Navegador({super.key});
  @override
  State<Navegador> createState() => _NavegadorState();
}

class _NavegadorState extends State<Navegador> {
  Widget? _cuerpo;
  final List<Widget> _pantallas = [];
  final List<BottomNavigationBarItem> _items = [];
  int _p = 0;
  String _nombreUsuario = 'Usuario'; // Valor por defecto
  String _rolUsuario = 'Desconocido'; // Valor por defecto
  bool _sesionIniciada = false; // Indica si el usuario ha iniciado sesión

  void _cambiaPantalla(int v) {
    setState(() {
      _p = v;
      _cuerpo = _pantallas[_p];
    });
  }

  Future<void> _cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombreUsuario') ?? 'Usuario';
      _rolUsuario = prefs.getString('rolUsuario') ?? 'Desconocido';
    });

    _configurarPantallas();
  }

  void _configurarPantallas() {
    _pantallas.clear();
    _items.clear();

    if (_nombreUsuario == 'Usuario') {
      // Pantalla login principal como índice 0
      _pantallas.add(
          principal(title: "Iniciar sesión", cambiarPantalla: _cambiaPantalla));
      _items.add(const BottomNavigationBarItem(
        label: "Home",
        icon: Icon(Icons.home),
      ));

      // Pantalla de registro como índice 1
      _pantallas.add(
          registrarse(title: 'Registrarse', cambiarPantalla: _cambiaPantalla));
      _items.add(const BottomNavigationBarItem(
        label: "Registro",
        icon: Icon(Icons.person_add),
      ));
    }

    // Pantallas según rol
    if (_rolUsuario == 'alumno') {
      _pantallas.add(
          alumno(title: 'Pase de Lista?', cambiarPantalla: _cambiaPantalla));
      _items.add(const BottomNavigationBarItem(
        label: "Clases",
        icon: Icon(Icons.school),
      ));

      _pantallas.add(InicioScreen(
        nombreUsuario: _nombreUsuario,
        esProfesor: false,
        cambiarPantalla: _cambiaPantalla,
      ));
      _items.add(const BottomNavigationBarItem(
        label: "Lista",
        icon: Icon(Icons.dashboard),
      ));
    } else if (_rolUsuario == 'profesor') {
      _pantallas.add(
          profesor(title: 'Pasar lista', cambiarPantalla: _cambiaPantalla));
      _items.add(const BottomNavigationBarItem(
        label: "Clases",
        icon: Icon(Icons.person),
      ));

      _pantallas.add(const ActProfesorScreen());
      _items.add(const BottomNavigationBarItem(
        label: "Listas",
        icon: Icon(Icons.assignment),
      ));
    }

    if (_rolUsuario == 'alumno' || _rolUsuario == 'profesor') {
      _pantallas.add(PerfilScreen(
        nombreUsuario: _nombreUsuario,
        rolUsuario: _rolUsuario,
      ));
      _items.add(const BottomNavigationBarItem(
        label: "Perfil",
        icon: Icon(Icons.account_circle),
      ));
    }

    setState(() {
      // Si el índice actual es mayor al nuevo total de pantallas, resetea a 0
      if (_p >= _pantallas.length) _p = 0;
      _cuerpo = _pantallas.isNotEmpty
          ? _pantallas[_p]
          : Center(child: Text("No hay pantallas"));
    });
  }

  void _mostrarLoading() {
    setState(() {
      _cuerpo = const Center(child: CircularProgressIndicator());
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _sesionIniciada = true;
        _cargarDatosUsuario();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cuerpo,
      bottomNavigationBar: (_nombreUsuario == "Usuario")
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _p,
              onTap: _cambiaPantalla,
              backgroundColor: const Color.fromARGB(255, 15, 20, 15),
              selectedItemColor: const Color.fromARGB(255, 93, 255, 142),
              unselectedItemColor: Colors.white,
              items: _items,
            ),
    );
  }
}
