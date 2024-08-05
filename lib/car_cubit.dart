import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/car_model.dart';
import 'package:flutter_application_1/car_repository.dart';
import 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  final CarRepository carRepository;

  CarCubit({required this.carRepository}) : super(CarInitial());

  Future<void> createCar(CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.createCar(car);
      final cars = await carRepository.getAllCars();
      print(cars);
      emit(CarSuccess(cars: cars));
      CarReload(cars: cars);
    } catch (e) {
      print("error");
      emit(CarError(message: e.toString()));
    }
  }


  Future<void> updateCar(CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.updateCar(car);
      final cars = await carRepository.getAllCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> deleteCar(int id) async {
    try {
      emit(CarLoading());
      await carRepository.deleteCar(id);
      final cars = await carRepository.getAllCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> fetchAllCars() async {
    try {
      emit(CarLoading());
      final cars = await carRepository.getAllCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }
}