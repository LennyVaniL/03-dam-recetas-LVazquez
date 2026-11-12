import 'package:flutter/material.dart';
import 'package:recetas_del_mayab/data/opiniones_db.dart';
import 'package:recetas_del_mayab/models/opinion.dart';

class FormularioScreen extends StatefulWidget {
	final Opinion? opinion; // null = nueva, con valor = editar
	final int? recetaId;

	const FormularioScreen({super.key, this.opinion, this.recetaId});

	@override
	State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
	final _formKey = GlobalKey<FormState>();
	late final TextEditingController _opinionCtrl;
	late final TextEditingController _autorCtrl;

	bool get _esEdicion => widget.opinion != null;

	@override
	void initState() {
		super.initState();
		_opinionCtrl = TextEditingController(text: widget.opinion?.opinion ?? '');
		_autorCtrl = TextEditingController(text: widget.opinion?.autor ?? '');
	}

	@override
	void dispose() {
		_opinionCtrl.dispose();
		_autorCtrl.dispose();
		super.dispose();
	}

	Future<void> _guardar() async {
		if (!_formKey.currentState!.validate()) return;
		final opinion = Opinion(
			id: widget.opinion?.id,
		recetaId: widget.opinion?.recetaId ?? widget.recetaId,
			opinion: _opinionCtrl.text.trim(),
			autor: _autorCtrl.text.trim(),
		);
		if (_esEdicion) {
			await OpinionesDb.instancia.actualizar(opinion);
		} else {
			await OpinionesDb.instancia.insert(opinion);
		}
		if (!mounted) return;
		Navigator.pop(context, true); // avisa que se guardó algo
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text(_esEdicion ? 'Editar opinión' : 'Nueva opinión')),
			body: Form(
				key: _formKey,
				child: ListView(
					padding: const EdgeInsets.all(16),
					children: [
						TextFormField(
							controller: _opinionCtrl,
							maxLines: 4,
							textCapitalization: TextCapitalization.sentences,
							decoration: const InputDecoration(
								labelText: 'Opinión',
								alignLabelWithHint: true,
								prefixIcon: Icon(Icons.format_quote),
								border: OutlineInputBorder(),
							),
							validator: (v) => (v == null || v.trim().length < 5)
									? 'Escribe al menos 5 caracteres'
									: null,
						),
						const SizedBox(height: 16),
						TextFormField(
							controller: _autorCtrl,
							textCapitalization: TextCapitalization.words,
							decoration: const InputDecoration(
								labelText: 'Autor',
								prefixIcon: Icon(Icons.person),
								border: OutlineInputBorder(),
							),
							validator: (v) =>
									(v == null || v.trim().isEmpty) ? 'Escribe el autor' : null,
						),
						const SizedBox(height: 24),
						FilledButton.icon(
							onPressed: _guardar,
							icon: const Icon(Icons.save),
							label: Text(_esEdicion ? 'Guardar cambios' : 'Guardar opinión'),
						),
					],
				),
			),
		);
	}

}
