import 'package:dartz/dartz_streaming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(primaryColor: Colors.green.shade800, accentColor: Colors.green.shade500),
      home: NumberTriviaPage(),

    );
  }
}
