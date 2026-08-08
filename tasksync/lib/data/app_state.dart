import 'package:flutter/material.dart';
import 'mock_repository.dart';
import 'models/project_model.dart';

enum TaskStatus { todo, done, approved, revision }

class AppTask {
  final String id;
  final String title;
  final String project;
  final String page;
  final Person assignee;
  final DateTime deadline;
  TaskStatus status;

  AppTask({
    required this.id,
    required this.title,
    required this.project,
    required this.page,
    required this.assignee,
    required this.deadline,
    this.status = TaskStatus.todo,
  });
}

class AppState extends ChangeNotifier {
  // Projects
  final List<Project> _projects = List.from(MockRepository.projects);
  List<Project> get projects => List.unmodifiable(_projects);

  void addProject(Project project) {
    _projects.insert(0, project);
    notifyListeners();
  }

  // Tasks
  final List<AppTask> _tasks = [
    // Todo tasks (Executive Focus List)
    AppTask(
      id: 't1',
      title: 'Create design system',
      project: 'Website Builder',
      page: 'All page',
      assignee: MockRepository.deksha,
      deadline: DateTime.now().add(const Duration(hours: 5)),
      status: TaskStatus.todo,
    ),
    AppTask(
      id: 't6',
      title: 'Icon set finalization',
      project: 'Website Builder',
      page: 'All page',
      assignee: MockRepository.deksha,
      deadline: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
      status: TaskStatus.todo,
    ),
    AppTask(
      id: 't9',
      title: 'Accessibility review',
      project: 'Finance landing',
      page: 'Checkout',
      assignee: MockRepository.deksha,
      deadline: DateTime.now().add(const Duration(hours: 26)),
      status: TaskStatus.todo,
    ),
    AppTask(
      id: 't10',
      title: 'Motion design specs',
      project: 'Mobile App',
      page: 'Onboarding',
      assignee: MockRepository.deksha,
      deadline: DateTime.now().add(const Duration(hours: 48)),
      status: TaskStatus.todo,
    ),

    // Done tasks (Co-Lead Audit Queue)
    AppTask(
      id: 't4',
      title: 'Typography audit',
      project: 'Logo Guideline',
      page: 'Brand',
      assignee: MockRepository.ana,
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.done,
    ),
    AppTask(
      id: 't5',
      title: 'Prototype animations',
      project: 'Mobile App',
      page: 'Onboarding',
      assignee: MockRepository.deksha,
      deadline: DateTime.now().subtract(const Duration(hours: 2)),
      status: TaskStatus.done,
    ),
    AppTask(
      id: 't6_audit',
      title: 'Icon set draft',
      project: 'Website Builder',
      page: 'All page',
      assignee: MockRepository.kush,
      deadline: DateTime.now().subtract(const Duration(days: 2)),
      status: TaskStatus.done,
    ),
    AppTask(
      id: 't7',
      title: 'Colour palette',
      project: 'Finance landing',
      page: 'Brand',
      assignee: MockRepository.guna,
      deadline: DateTime.now().subtract(const Duration(days: 3)),
      status: TaskStatus.done,
    ),
    AppTask(
      id: 't8',
      title: 'Component library',
      project: 'Website Builder',
      page: 'Design System',
      assignee: MockRepository.ana,
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.done,
    ),
  ];

  List<AppTask> get tasks => List.unmodifiable(_tasks);

  void completeTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].status = TaskStatus.done;
      notifyListeners();
    }
  }

  void approveTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].status = TaskStatus.approved;
      notifyListeners();
    }
  }

  void reopenTask(String id, String feedback) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].status = TaskStatus.todo;
      // In a real app we might store feedback too
      notifyListeners();
    }
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateScope>()!
        .notifier!;
  }
}
