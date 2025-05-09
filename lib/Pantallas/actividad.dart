import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ActividadScreen extends StatefulWidget {
  const ActividadScreen({super.key});

  @override
  State<ActividadScreen> createState() => _ActividadScreenState();
}

class _ActividadScreenState extends State<ActividadScreen> {
  // Mapa para almacenar las fechas con asistencias (normalizadas)
  final Map<DateTime, List<String>> _asistencias = {
    DateTime(2025, 5, 8): ['Matemáticas', 'Historia'],
    DateTime(2025, 5, 9): ['Ciencias'],
    DateTime(2025, 5, 10): ['Inglés', 'Programación'],
    DateTime(2025, 5, 11): ['Historia'],
    DateTime(2025, 5, 12): ['Matemáticas', 'Ciencias', 'Inglés'],
  };

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Función para normalizar las fechas (eliminar la información de tiempo)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
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
                  Color(0xFF004D40), // Verde oscuro
                  Color(0xFF000000), // Negro
                ],
              ),
            ),
          ),
          // Contenido principal
          Column(
            children: [
              const SizedBox(height: 30), // Reducimos el espacio superior
              // Título centrado
              Center(
                child: Text(
                  'Mi Actividad',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Contenedor del calendario
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withOpacity(0.1), // Fondo semitransparente
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white, // Color del borde
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TableCalendar(
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2030),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = _normalizeDate(selectedDay);
                          _focusedDay = focusedDay;
                        });
                      },
                      eventLoader: (day) {
                        return _asistencias[_normalizeDate(day)] ?? [];
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF00796B), // Verde medio
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: const Color(0xFF004D40), // Verde oscuro
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: const BoxDecoration(
                          color:
                              Colors.red, // Color de los puntos de asistencia
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: const TextStyle(color: Colors.white),
                        weekendTextStyle:
                            const TextStyle(color: Colors.white70),
                        todayTextStyle: const TextStyle(color: Colors.black),
                        selectedTextStyle: const TextStyle(color: Colors.black),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Colors.white),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.white),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.white70),
                        weekendStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Lista de asistencias para el día seleccionado
              Expanded(
                child: _selectedDay != null &&
                        _asistencias[_selectedDay] != null
                    ? ListView.builder(
                        itemCount: _asistencias[_selectedDay]!.length,
                        itemBuilder: (context, index) {
                          final clase = _asistencias[_selectedDay]![index];
                          return ListTile(
                            leading: const Icon(Icons.check_circle,
                                color: Color.fromARGB(255, 93, 255, 142)),
                            title: Text(
                              clase,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No hay asistencias registradas para este día.',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
