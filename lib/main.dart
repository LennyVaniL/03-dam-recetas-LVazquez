import 'package:flutter/material.dart';
import 'data/database_initializer.dart';
import 'package:recetas_del_mayab/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const RecetasApp());
}

class RecetasApp extends StatelessWidget{
  const RecetasApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Recetas del Mayab",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}