class Receta {                        // class Recetas: Declaración de la clase y sus atributos
  final int id;                       // final: Una ves asignado el valor no puede ser modificado
  final String nombre;
  final List<String> ingredientes;    // int: tipo de dato numerico entero
  final List<String> instrucciones;   // string: Tipo de dato de texto/cadena
  final int tiempoPreparacion;        // list<string>: List - coleción de elemnetos, <string> - los elemnetos son de tipo de texto/cadena
  final int tiempoCoccion;
  final int porciones;
  final int calorias;
  final String imagenUrl;
  final double calificacion;
  final String cocina;
  final String dificultad;

  const Receta({                      // const: El constructor - un constructor permite crear objetos de una clase. De igual manera permite crear instancias constantes cuando todos sus argumentos son constantes
    required this.id,                 // required: Esta palabra obliga a proporcionar ese parametro al crear el objeto
    required this.nombre,             // this. : significa que estamos asignado un valor al atributo
    required this.ingredientes,
    required this.instrucciones,
    required this.tiempoPreparacion,
    required this.tiempoCoccion,
    required this.porciones,
    required this.calorias,
    required this.imagenUrl,
    required this.calificacion,
    required this.cocina,
    required this.dificultad

  });

  factory Receta.fromJson(Map<String, dynamic> json) {                    // se podria decir que en esta linea convirte la información que resibimos del JSON en objeto de un tipo Receta
    return Receta(                                                        //Map: Estructura de dato de tipo diccionario. Se podria decir que es de tipo "coleccion" ya que almacena elemntos de tipo CLAVE-VALOR
      id: json['id'],                                                     // dynamic: permite que los valores sean de distinto tipo
      nombre: json['name'],                                               
      ingredientes: List<String>.from(json['ingredients']),               // <-    .front: transforma la lista obtenida del JSON en una lista de cadena de texto de dart 
      instrucciones: List<String>.from(json['instructions']),
      tiempoPreparacion: json['prepTimeMinutes'],
      tiempoCoccion: json['cookTimeMinutes'],
      porciones: json['servings'],
      calorias: json['caloriesPerServing'],
      imagenUrl: json['image'],
      calificacion: (json['rating'] as num).toDouble(),                   //<- convierte una calificación numérica recibida desde JSON en un double.
      dificultad: json['difficulty'],
      cocina: json['cuisine'],
    );
  }

  int get tiempoTotal => tiempoPreparacion + tiempoCoccion;               // <- Esto es un getter, una propiedad calculda. No almacena un dato adicional, sino que calcula un resultado a partir de otros atributos.
}
