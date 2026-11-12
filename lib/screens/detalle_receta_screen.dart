import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../models/opinion.dart';
import 'package:recetas_del_mayab/screens/formulario_opinion_screen.dart';
import 'package:recetas_del_mayab/data/opiniones_db.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({
    super.key,
    required this.receta,
  });



  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  final _opinionesDb = OpinionesDb.instancia;
  List<Opinion> _opiniones = [];
  bool _cargandoOpiniones = true;
  String? _errorOpiniones;

  Receta get receta => widget.receta;

  @override
  void initState() {
    super.initState();
    _cargarOpiniones();
  }

  Future<void> _cargarOpiniones() async {
    setState(() {
      _cargandoOpiniones = true;
      _errorOpiniones = null;
    });
    try {
      final opiniones = await _opinionesDb.obtenerPorReceta(receta.id);
      if (!mounted) return;
      setState(() {
        _opiniones = opiniones;
        _cargandoOpiniones = false;
      });
    } catch (error) {
      debugPrint('Error al cargar reseñas: $error');
      if (!mounted) return;
      setState(() {
        _errorOpiniones = 'No se pudieron cargar las reseñas.';
        _cargandoOpiniones = false;
      });
    }
  }

  Future<void> _crearOpinion() async {
    final guardada = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioScreen(recetaId: receta.id),
      ),
    );
    if (guardada == true) await _cargarOpiniones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: Image.network(
                      receta.imagenUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receta.nombre,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2518),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _infoChip(Icons.timer_outlined, '${receta.tiempoTotal} min'),
                        _infoChip(Icons.people_alt_outlined, '${receta.porciones} porciones'),
                        _infoChip(Icons.local_fire_department_outlined, '${receta.calorias} kcal'),
                        _infoChip(Icons.star_outline, receta.calificacion.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Ingredientes:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2518),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...receta.ingredientes.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final ingrediente = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(top: 7, right: 10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD97706),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${index + 1}. $ingrediente',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF2F241F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Preparación:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2518),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...receta.instrucciones.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final paso = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C4D2E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  paso,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Color(0xFF2F241F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _seccionOpiniones(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionOpiniones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reseñas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2518),
              ),
            ),
            TextButton.icon(
              onPressed: _crearOpinion,
              icon: const Icon(Icons.rate_review_outlined),
              label: const Text('Escribir'),
            ),
          ],
        ),
        if (_cargandoOpiniones)
          const Center(child: CircularProgressIndicator())
        else if (_errorOpiniones != null)
          Row(
            children: [
              Expanded(child: Text(_errorOpiniones!)),
              IconButton(
                tooltip: 'Reintentar',
                onPressed: _cargarOpiniones,
                icon: const Icon(Icons.refresh),
              ),
            ],
          )
        else if (_opiniones.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Aún no hay reseñas para esta receta.'),
          )
        else
          ..._opiniones.map(
            (opinion) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.account_circle_outlined, color: Color(0xFF7C4D2E)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opinion.autor,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(opinion.opinion),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFD97706)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF3E2518),
            ),
          ),
        ],
      ),
    );
  }


}
