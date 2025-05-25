class MotivoVisita {
  final int codigo;
  final String descripcion;

  MotivoVisita({required this.codigo, required this.descripcion});

  factory MotivoVisita.fromJson(Map<String, dynamic> json) {
    return MotivoVisita(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
    );
  }
}
