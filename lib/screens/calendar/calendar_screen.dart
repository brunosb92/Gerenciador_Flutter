// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/auth_service.dart';
import '../../services/task_service.dart';
import '../auth/login_screen.dart';
import '../tasks/task_screen.dart';

class CalendarScreen extends StatefulWidget {
  final String userEmail;

  const CalendarScreen({super.key, required this.userEmail});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _userName = 'Usuário';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _userName = authService.getName(widget.userEmail) ?? 'Visitante';
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _navigateToTasks() async {
    if (_selectedDay != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskScreen(
            selectedDate: _selectedDay!,
            userEmail: widget.userEmail,
          ),
        ),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecione uma data primeiro.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 60,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Gerenciador de Tarefas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Gerencie seu tempo de forma inteligente!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _logout,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: const Text(
                        'Sair',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, -5)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Olá, ',
                              style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).primaryColor,
                              ),
                              children: [
                                TextSpan(
                                  text: '$_userName!',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Selecione um dia no calendário e clique em "confirmar data" para gerenciar suas tarefas.',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildLegendItem(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                label: 'Hoje',
                              ),
                              _buildLegendItem(
                                color: Theme.of(context).colorScheme.secondary,
                                label: 'Selecionada',
                              ),
                              _buildLegendItem(
                                color: Colors.green,
                                label: 'Com Tarefa',
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: TableCalendar(
                            locale: 'pt_BR',
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            eventLoader: (day) {
                              return taskService.getTasksForDay(
                                  widget.userEmail, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            rowHeight: 42,
                            daysOfWeekHeight: 25,
                            calendarStyle: CalendarStyle(
                              markerDecoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              markersMaxCount: 1,
                              selectedDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                              outsideDaysVisible: false,
                              defaultTextStyle: const TextStyle(fontSize: 15),
                              weekendTextStyle: const TextStyle(
                                  fontSize: 15, color: Colors.redAccent),
                            ),
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              leftChevronIcon: Icon(Icons.chevron_left,
                                  size: 24, color: Colors.grey),
                              rightChevronIcon: Icon(Icons.chevron_right,
                                  size: 24, color: Colors.grey),
                              headerPadding: EdgeInsets.symmetric(vertical: 5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _navigateToTasks,
                            child: const Text('Confirmar Data'),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ],
    );
  }
}
