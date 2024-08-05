import 'package:flutter/material.dart';
import 'package:flutter_application_1/car_cubit.dart';
import 'package:flutter_application_1/car_model.dart';
import 'package:flutter_application_1/car_repository.dart';
import 'package:flutter_application_1/car_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class CarListView extends StatelessWidget {
  const CarListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarCubit(
        carRepository: RepositoryProvider.of<CarRepository>(context),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: const CarListScreen(),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Profe, cada vez que agregue o edite un carro dele a Fetch Cars pq no logre que se refrescara automatico 😢😢😢(pero fuera de eso todo funciona bien)',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CarForm(),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class CarListScreen extends StatefulWidget {
  const CarListScreen({Key? key}) : super(key: key);

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late CarCubit carCubit;

  @override
  void initState() {
    super.initState();
    carCubit = BlocProvider.of<CarCubit>(context);
    carCubit.fetchAllCars(); // Cargar la lista de autos automáticamente
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              carCubit.fetchAllCars();
            },
            child: const Text('Fetch Cars'),
            style: ElevatedButton.styleFrom(
            ),
          ),
          Expanded(
            child: BlocBuilder<CarCubit, CarState>(
              builder: (context, state) {
                if (state is CarLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CarSuccess) {
                  final cars = state.cars;
                  return ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('${car.mark} (${car.model})'),
                          subtitle: Text('Velocidad Máxima: ${car.topSpeed} km/h, Peso: ${car.peso} kg'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CarForm(car: car),
                                  );
                                },
                                color: Colors.teal[700],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Car'),
                                      content: Text('Are you sure you want to delete this car?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            carCubit.deleteCar(car.id);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                color: Colors.red[700],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CarError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('Press the button to fetch cars'));
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CarForm extends StatefulWidget {
  final CarModel? car;

  CarForm({Key? key, this.car}) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _markController;
  late TextEditingController _modelController;
  late TextEditingController _pesoController;
  late TextEditingController _topSpeedController;

  @override
  void initState() {
    super.initState();
    _markController = TextEditingController(text: widget.car?.mark);
    _modelController = TextEditingController(text: widget.car?.model);
    _pesoController = TextEditingController(text: widget.car?.peso.toString());
    _topSpeedController = TextEditingController(text: widget.car?.topSpeed.toString());
  }

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);

    return AlertDialog(
      title: Text(widget.car == null ? 'Create Car' : 'Update Car'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _markController,
              decoration: InputDecoration(
                labelText: 'Mark',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a mark';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: 'Model',
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a model';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _pesoController,
              decoration: InputDecoration(
                labelText: 'Peso',
                filled: true,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the peso';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _topSpeedController,
              decoration: InputDecoration(
                labelText: 'Top Speed',
                filled: true,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the top speed';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final car = CarModel(
                id: 0,
                qwerty:"",
                mark: _markController.text,
                model: _modelController.text,
                peso: double.parse(_pesoController.text),
                topSpeed: double.parse(_topSpeedController.text),
              );
              final randomNumber = generateFourDigitNumber();
              if (widget.car == null) {
                car.id = randomNumber;
                car.qwerty = randomNumber.toString();
                carCubit.createCar(car);
              } else {
                car.id = widget.car!.id;
                car.qwerty = widget.car!.qwerty;
                carCubit.updateCar(car).then((_) => carCubit.fetchAllCars());
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}


int generateFourDigitNumber() {
  final random = Random();
  return 1000 + random.nextInt(9000); // Genera un número entre 1000 y 9999
}