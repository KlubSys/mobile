import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klub/application.dart';
import 'package:klub/data/repositories/klub-api.repository.dart';
import 'package:klub/presentation/screens/home.screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => KlubApiRepository(Application.klubApi),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          title: "Klub",
          theme: ThemeData(
            primaryColor: Colors.indigo,
            scaffoldBackgroundColor: Colors.white,
          ),
          //const HomeScreen()),//
          home: const HomeScreen()),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
