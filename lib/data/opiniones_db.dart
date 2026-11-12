import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/opinion.dart';


class OpinionesDb {
	OpinionesDb._();

	static final OpinionesDb instancia = OpinionesDb._();
	static const _nombreArchivo = 'misopiniones.db';
	static const _tabla = 'opiniones';
	static const _version = 2;
	Database? _db;

	// devuelve la bd abierta (la abre solo la primera vez). PDb: Singleton
	Future<Database> get _database async {
		_db ??= await _abrir();
		return _db!;
	}

	Future<Database> _abrir() async {
		final ruta = join(await getDatabasesPath(), _nombreArchivo);
		return openDatabase(
			ruta,
			version: _version,
			onCreate: (db, version) async {
				await db.execute('''
				CREATE TABLE $_tabla (
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					opinion TEXT NOT NULL,
					autor TEXT NOT NULL,
					receta_id INTEGER
				)
				''');
			},
			onUpgrade: (db, oldVersion, newVersion) async {
				if (oldVersion < 2) {
					await db.execute('ALTER TABLE $_tabla ADD COLUMN receta_id INTEGER');
				}
			},
		);
	}

	// Guarda una opinión y devuelve el id asignado por SQLite.
	Future<int> insert(Opinion opinion) async {
		final db = await _database;
		return db.insert(_tabla, opinion.toMap());
	}

	// Lee todas las opiniones de manera descendente.
	Future<List<Opinion>> obtenerTodas() async {
		final db = await _database;
		final filas = await db.query(_tabla, orderBy: 'id DESC');
		return filas.map(Opinion.fromMap).toList();
	}

	Future<List<Opinion>> obtenerPorReceta(int recetaId) async {
		final db = await _database;
		final filas = await db.query(
			_tabla,
			where: 'receta_id = ?',
			whereArgs: [recetaId],
			orderBy: 'id DESC',
		);
		return filas.map(Opinion.fromMap).toList();
	}

	// Modifica una opinión usando su id.
	Future<int> actualizar(Opinion opinion) async {
		final db = await _database;
		return db.update(
			_tabla,
			opinion.toMap(),
			where: 'id = ?',
			whereArgs: [opinion.id],
		);
	}

	// Elimina una opinión usando su id.
	Future<int> eliminar(int id) async {
		final db = await _database;
		return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
	}
}
