import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Notas de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskListPage(),
    );
  }
}
class Task {
  final String id;
  bool completed;

  Task({required this.id, this.completed = false});
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Task> _tasks = [
    Task(id: 'Task 2022-07-09\n18:08:31.734244'),
    Task(id: 'Task 2022-07-09\n18:08:32.210300'),
    Task(id: 'Task 2022-07-09\n18:08:32.629026'),
    Task(id: 'Task 2022-07-09\n18:08:33.073472'),
    Task(id: 'Task 2022-07-09\n18:08:33.524172'),
  ];

  bool _showCompleted = false;

  List<Task> get _visibleTasks =>
      _showCompleted ? _tasks : _tasks.where((t) => !t.completed).toList();

  int get _uncompletedCount => _tasks.where((t) => !t.completed).length;

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text(
          'Essa feature não está implementada ainda! :(\nVolte na próxima atualização.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleCompleted() {
    setState(() => _showCompleted = !_showCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Kindacode.com'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ElevatedButton(
              onPressed: _toggleCompleted,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                textStyle: const TextStyle(fontSize: 11),
              ),
              child: Text(
                _showCompleted ? 'Hide Completed' : 'View Completed Tasks',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'You have $_uncompletedCount uncompleted tasks',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),

          Expanded(
            child: _visibleTasks.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma tarefa pendente!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _visibleTasks.length,
                    itemBuilder: (context, index) {
                      final task = _visibleTasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Card(
                          color: task.completed
                              ? Colors.grey[200]
                              : Colors.amber[300],
                          elevation: 1,
                          child: ListTile(
                            title: Text(
                              task.id,
                              style: TextStyle(
                                fontSize: 13,
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.completed ? Colors.grey : null,
                              ),
                            ),
                            trailing: Checkbox(
                              value: task.completed,
                              activeColor: Colors.blue,
                              onChanged: (val) {
                                setState(() => task.completed = val ?? false);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAboutDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
