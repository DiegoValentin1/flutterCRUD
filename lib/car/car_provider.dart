import 'package:flutter/material.dart';
import 'package:flutter_application_1/car/Car.dart';

class CarProvider with ChangeNotifier {
  List<Car> _cars = [];
  int _nextId = 1;

  List<Car> get cars => _cars;

  void addCar(Car car) {
    car.id = _nextId++;
    _cars.add(car);
    notifyListeners();
  }

  void updateCar(Car car) {
    int index = _cars.indexWhere((c) => c.id == car.id);
    if (index != -1) {
      _cars[index] = car;
      notifyListeners();
    }
  }

  void deleteCar(int id) {
    _cars.removeWhere((car) => car.id == id);
    notifyListeners();
  }
}
