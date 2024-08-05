import 'package:flutter/material.dart';
import 'package:flutter_application_1/car_cubit.dart';
import 'package:flutter_application_1/car_repository.dart';
import 'package:flutter_application_1/car_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CarRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => CarCubit(
          carRepository: RepositoryProvider.of<CarRepository>(context),
        ),
        child: MaterialApp(
          title: 'Car App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const CarListView(),
        ),
      ),
    );
  }
}