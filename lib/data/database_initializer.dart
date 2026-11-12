import 'database_initializer_stub.dart'
    if (dart.library.io) 'database_initializer_io.dart' as implementation;

Future<void> initializeDatabase() => implementation.initializeDatabase();