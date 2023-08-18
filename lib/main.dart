import 'package:flutter/material.dart';
import 'Screens/task_screen.dart';
import 'database/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
=======

      theme: ThemeData(
      ),
>>>>>>> 2952aadb7bdf3b50ba52cec25b55bbc3720b036d
      home: const task_screen(),
    );
  }
}
