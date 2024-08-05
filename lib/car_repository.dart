import 'dart:convert';
import 'package:flutter_application_1/car_model.dart';
import 'package:http/http.dart' as http;

class CarRepository {
  final String apiUrl =
      'https://5a60zyoec3.execute-api.us-east-2.amazonaws.com/items';

  Future<void> createCar(CarModel car) async {
    final response = await http.put(
      Uri.parse('$apiUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()),
    );

    print(response);
    print(car.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to create car');
    }
  }

  Future<void> updateCar(CarModel car) async {
    final response = await http.put(
      Uri.parse('$apiUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car');
    }
  }

  Future<void> deleteCar(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete car');
    }
  }

  Future<List<CarModel>> getAllCars() async {
  final response = await http.get(
    Uri.parse('$apiUrl'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> carsData = json.decode(response.body);
    return carsData.map((carData) => CarModel.fromJson(carData)).toList();
  } else {
    throw Exception('Failed to load cars');
  }
}

}