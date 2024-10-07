import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskListScreen(),
    );
  }
}

class Task {
  String name;
  bool isCompleted;
  String priority;

  Task({required this.name, this.isCompleted = false, required this.priority});
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Low';

  // Method to add a task
  void _addTask(String taskName, String priority) {
    if (taskName.isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: taskName, priority: priority));
        _taskController.clear();
      });
    }
  }

  // Method to toggle task completion
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  // Method to remove a task
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Sort tasks based on priority (High -> Medium -> Low)
  List<Task> _getSortedTasks() {
    List<Task> sortedTasks = List.from(_tasks);
    sortedTasks.sort((a, b) {
      const priorityOrder = {'High': 1, 'Medium': 2, 'Low': 3};
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });
    return sortedTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Task input and Add button
            Row(
              children: [
                // Text input field for task name
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown for priority selection
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: const [
                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'High', child: Text('High')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addTask(_taskController.text, _selectedPriority),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Task list
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('No tasks yet!'))
                  : ListView.builder(
                      itemCount: _getSortedTasks().length,
                      itemBuilder: (context, index) {
                        final task = _getSortedTasks()[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) => _toggleTaskCompletion(index),
                            ),
                            title: Text(
                              task.name,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text('Priority: ${task.priority}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
