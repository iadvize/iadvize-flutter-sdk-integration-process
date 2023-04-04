import 'package:flutter/material.dart';

void main() {
  runApp(const IntegrationDemoApp());
}

class IntegrationDemoApp extends StatelessWidget {
  const IntegrationDemoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iAvize SDK Flutter Plugin Integration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(title: 'Home'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.title)));
  }
}
