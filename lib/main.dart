import 'package:flutter/material.dart';
import 'package:flutter_application_1/car.dart';
import 'package:flutter_application_1/car_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarListScreen(),
    );
  }
}

class CarListScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _velocidadMaximaController = TextEditingController();
  final _pesoController = TextEditingController();
  Car? _selectedCar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Carros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _marcaController,
                    decoration: InputDecoration(labelText: 'Marca'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la marca';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _modeloController,
                    decoration: InputDecoration(labelText: 'Modelo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el modelo';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _velocidadMaximaController,
                    decoration: InputDecoration(labelText: 'Velocidad Máxima'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la velocidad máxima';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pesoController,
                    decoration: InputDecoration(labelText: 'Peso'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el peso';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedCar == null) {
                              Provider.of<CarProvider>(context, listen: false).addCar(
                                Car(
                                  id: 0,
                                  marca: _marcaController.text,
                                  modelo: _modeloController.text,
                                  velocidadMaxima: double.parse(_velocidadMaximaController.text),
                                  peso: double.parse(_pesoController.text),
                                ),
                              );
                            } else {
                              _selectedCar!.marca = _marcaController.text;
                              _selectedCar!.modelo = _modeloController.text;
                              _selectedCar!.velocidadMaxima = double.parse(_velocidadMaximaController.text);
                              _selectedCar!.peso = double.parse(_pesoController.text);
                              Provider.of<CarProvider>(context, listen: false).updateCar(_selectedCar!);
                              _selectedCar = null;
                            }
                            _formKey.currentState!.reset();
                          }
                        },
                        child: Text(_selectedCar == null ? 'Agregar' : 'Actualizar'),
                      ),
                      if (_selectedCar != null)
                        ElevatedButton(
                          onPressed: () {
                            _selectedCar = null;
                            _formKey.currentState!.reset();
                          },
                          child: Text('Cancelar'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<CarProvider>(
                builder: (context, carProvider, child) {
                  return ListView.builder(
                    itemCount: carProvider.cars.length,
                    itemBuilder: (context, index) {
                      final car = carProvider.cars[index];
                      return ListTile(
                        title: Text('${car.marca} ${car.modelo}'),
                        subtitle: Text('Velocidad: ${car.velocidadMaxima} km/h, Peso: ${car.peso} kg'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _marcaController.text = car.marca;
                                _modeloController.text = car.modelo;
                                _velocidadMaximaController.text = car.velocidadMaxima.toString();
                                _pesoController.text = car.peso.toString();
                                _selectedCar = car;
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Provider.of<CarProvider>(context, listen: false).deleteCar(car.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
