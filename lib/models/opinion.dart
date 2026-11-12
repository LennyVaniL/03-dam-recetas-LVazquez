class Opinion {
	final int? id;
	final String opinion;
	final String autor;

	const Opinion({this.id, required this.opinion, required this.autor});

	// objeto -> map (para guardar en sqlite
	Map<String, Object?> toMap() {
		return {if (id != null) 'id': id, 'opinion': opinion, 'autor': autor};
	}

	// Mapa (una fila de SQLite) -> objeto
	factory Opinion.fromMap(Map<String, Object?> mapa) {
		return Opinion(
			id: mapa['id'] as int?,
			opinion: mapa['opinion'] as String,
			autor: mapa['autor'] as String,
		);
	}
}
