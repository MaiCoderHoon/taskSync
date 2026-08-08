import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasksync/screens/auth/gateway_screen.dart';
import 'package:tasksync/theme/theme.dart';

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

class TaskSyncApp extends StatelessWidget {
  const TaskSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const GatewayScreen(),
    );
  }
}
