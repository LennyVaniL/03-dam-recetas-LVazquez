class Opinion {
	final int? id;
	final int? recetaId;
	final String opinion;
	final String autor;

	const Opinion({this.id, this.recetaId, required this.opinion, required this.autor});

	// objeto -> map (para guardar en sqlite
	Map<String, Object?> toMap() {
		return {
			if (id != null) 'id': id,
			if (recetaId != null) 'receta_id': recetaId,
			'opinion': opinion,
			'autor': autor,
		};
	}

	// Mapa (una fila de SQLite) -> objeto
	factory Opinion.fromMap(Map<String, Object?> mapa) {
		return Opinion(
			id: mapa['id'] as int?,
			recetaId: mapa['receta_id'] as int?,
			opinion: mapa['opinion'] as String,
			autor: mapa['autor'] as String,
		);
	}
}
