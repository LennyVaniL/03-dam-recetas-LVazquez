// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recetas_del_mayab/data/database_initializer.dart';
import 'package:recetas_del_mayab/data/opiniones_db.dart';
import 'package:recetas_del_mayab/models/receta.dart';
import 'package:recetas_del_mayab/screens/detalle_receta_screen.dart';

void main() {
  test('inicializa la base SQLite local', () async {
    await initializeDatabase();
    final opiniones = await OpinionesDb.instancia.obtenerPorReceta(-1);

    expect(opiniones, isEmpty);
  });

  testWidgets('muestra la información principal de la receta', (tester) async {
    final receta = Receta(
      id: 1,
      nombre: 'Pozole rojo',
      ingredientes: ['Maíz', 'Chile', 'Pollo'],
      instrucciones: ['Hervir el maíz', 'Preparar la salsa', 'Servir caliente'],
      tiempoPreparacion: 20,
      tiempoCoccion: 30,
      porciones: 4,
      calorias: 320,
      imagenUrl: 'https://example.com/pozole.jpg',
      calificacion: 4.8,
      cocina: 'Mexicana',
      dificultad: 'Media',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DetalleRecetaScreen(receta: receta),
      ),
    );

    expect(find.text('Pozole rojo'), findsOneWidget);
    expect(find.text('Ingredientes:'), findsOneWidget);
    expect(find.text('1. Maíz'), findsOneWidget);
    expect(find.text('Preparación:'), findsOneWidget);
    expect(find.text('Reseñas'), findsOneWidget);
    expect(find.text('Escribir'), findsOneWidget);
  });
}
