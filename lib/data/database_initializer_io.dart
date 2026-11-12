import 'dart:io';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

Future<void> initializeDatabase() async {
  if (Platform.isLinux || Platform.isWindows) {
    ffi.sqfliteFfiInit();
    sqflite.databaseFactory = ffi.databaseFactoryFfi;
  }
}