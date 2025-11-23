import 'dart:math';

// MODELO DE DADOS
class Task {
  final String id;
  String title;
  bool isCompleted;
  DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
  });
}

// SERVIÇO MOCK (EM MEMÓRIA)
class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  // Armazena tarefas POR USUÁRIO.
  // Estrutura: { 'email_usuario': { DateTime: [Lista de Tarefas] } }
  final Map<String, Map<DateTime, List<Task>>> _userTasks = {};

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Task> _sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return tasks;
  }

  // Métodos CRUD exigindo o userId (email)

  // READ
  List<Task> getTasksForDay(String userId, DateTime date) {
    final normalizedDate = _normalizeDate(date);
    // Verifica se o usuário tem tarefas, depois se tem tarefas na data
    final tasks = _userTasks[userId]?[normalizedDate];

    if (tasks != null) {
      return _sortTasks(List<Task>.from(tasks));
    }
    return [];
  }

  // CREATE
  Task addTask(String userId, String title, DateTime date) {
    final normalizedDate = _normalizeDate(date);
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString() +
          Random().nextInt(1000).toString(),
      title: title,
      isCompleted: false,
      date: normalizedDate,
    );

    // Garante que a estrutura para o usuário e data exista
    if (!_userTasks.containsKey(userId)) {
      _userTasks[userId] = {};
    }
    if (!_userTasks[userId]!.containsKey(normalizedDate)) {
      _userTasks[userId]![normalizedDate] = [];
    }

    _userTasks[userId]![normalizedDate]!.add(newTask);
    return newTask;
  }

  // UPDATE (Título)
  void editTask(String userId, String taskId, String newTitle, DateTime date) {
    final normalizedDate = _normalizeDate(date);
    final tasks = _userTasks[userId]?[normalizedDate];

    if (tasks != null) {
      final taskIndex = tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex].title = newTitle;
      }
    }
  }

  // UPDATE (Status)
  void toggleTaskStatus(String userId, String taskId, DateTime date) {
    final normalizedDate = _normalizeDate(date);
    final tasks = _userTasks[userId]?[normalizedDate];

    if (tasks != null) {
      final taskIndex = tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex].isCompleted = !tasks[taskIndex].isCompleted;
      }
    }
  }

  // DELETE
  void deleteTask(String userId, String taskId, DateTime date) {
    final normalizedDate = _normalizeDate(date);
    final userMap = _userTasks[userId];

    if (userMap != null) {
      userMap[normalizedDate]?.removeWhere((t) => t.id == taskId);

      if (userMap[normalizedDate]?.isEmpty ?? false) {
        userMap.remove(normalizedDate);
      }
    }
  }
}

final taskService = TaskService();
