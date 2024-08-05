class CarModel {
  int id;
  String qwerty;
  final String mark;
  final String model;
  final double peso;
  final double topSpeed;

  CarModel({
    required this.id,
    required this.qwerty,
    required this.mark,
    required this.model,
    required this.peso,
    required this.topSpeed,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      qwerty: json['qwerty'],
      mark: json['marca'],
      model: json['modelo'],
      peso: json['peso'].toDouble(),
      topSpeed: json['maxVel'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qwerty': qwerty,
      'marca': mark,
      'modelo': model,
      'peso': peso,
      'maxVel': topSpeed,
    };
  }
}