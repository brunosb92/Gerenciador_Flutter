import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/task_service.dart';

class TaskScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String userEmail;

  const TaskScreen({
    super.key,
    required this.selectedDate,
    required this.userEmail,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      // Busca tarefas ordenadas do serviço
      _tasks =
          taskService.getTasksForDay(widget.userEmail, widget.selectedDate);
    });
  }

  void _showTaskDialog({Task? task}) {
    // Se task não for null, preenche o campo com o título existente.
    final titleController = TextEditingController(text: task?.title ?? '');
    final isEditing = task != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isEditing ? 'Editar Tarefa' : 'Nova Tarefa',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'O que precisa ser feito?',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          // Botão Cancelar
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancelar'),
          ),

          // Botão Salvar
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                if (isEditing) {
                  taskService.editTask(
                    widget.userEmail,
                    task.id,
                    titleController.text.trim(),
                    widget.selectedDate,
                  );
                } else {
                  taskService.addTask(
                    widget.userEmail,
                    titleController.text.trim(),
                    widget.selectedDate,
                  );
                }
                _loadTasks(); // Recarrega a lista
                Navigator.pop(ctx); // Fecha o diálogo
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              taskService.deleteTask(
                  widget.userEmail, task.id, widget.selectedDate);
              _loadTasks();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tarefa removida')),
              );
            },
            child: const Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(Task task) {
    taskService.toggleTaskStatus(
        widget.userEmail, task.id, widget.selectedDate);
    _loadTasks();
  }

  // Função auxiliar para construir o item da lista
  Widget _buildTaskItem(Task task) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      // Muda a cor se estiver concluída
      color: task.isCompleted ? Colors.grey[100] : Colors.white,
      child: ListTile(
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => _toggleStatus(task),
            activeColor: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black87,
            fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mostra editar se a tarefa não estiver concluída.
            if (!task.isCompleted)
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                onPressed: () => _showTaskDialog(task: task),
                tooltip: 'Editar',
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteTask(task),
              tooltip: 'Excluir',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Separa as tarefas em duas listas para exibição (Pendentes/Completadas)
    final pendingTasks = _tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = _tasks.where((t) => t.isCompleted).toList();

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              // CABEÇALHO.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // LOGO
                    Image.asset('assets/images/logo.png', height: 50),
                    const SizedBox(width: 15),

                    // TITULO E DATA CENTRALIZADOS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Gerenciar Tarefas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(widget.selectedDate),
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // BOTAO VOLTAR
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      tooltip: 'Voltar',
                    ),
                  ],
                ),
              ),

              // CONTEÚDO PRINCIPAL (CardBranco)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      // BOTAO "ADICIONAR NOVA TAREFA"
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => _showTaskDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Adicionar Nova Tarefa',
                                style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // LISTA DE TAREFAS
                      Expanded(
                        child: _tasks.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.task_alt,
                                        size: 60, color: Colors.grey[300]),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Nenhuma tarefa para este dia.',
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  // SEÇÃO PENDENTES
                                  if (pendingTasks.isNotEmpty) ...[
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        'Pendentes',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                    ...pendingTasks
                                        .map((task) => _buildTaskItem(task)),
                                  ],

                                  // SEÇÃO CONCLUÍDAS
                                  if (completedTasks.isNotEmpty) ...[
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 10),
                                      child: Text(
                                        'Concluídas',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    ...completedTasks
                                        .map((task) => _buildTaskItem(task)),
                                  ],

                                  const SizedBox(
                                      height: 40), // Espaço extra no final
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
