import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasksync/screens/auth/gateway_screen.dart';
import 'package:tasksync/theme/theme.dart';
import 'package:tasksync/data/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar — content bleeds under it
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const TaskSyncApp());
}

class TaskSyncApp extends StatefulWidget {
  const TaskSyncApp({super.key});

  @override
  State<TaskSyncApp> createState() => _TaskSyncAppState();
}

class _TaskSyncAppState extends State<TaskSyncApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        title: 'TaskSync',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const GatewayScreen(),
      ),
    );
  }
}
