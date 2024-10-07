import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lati_marvel/helpers/consts.dart';
import 'package:lati_marvel/providers/base_provider.dart';
import 'package:lati_marvel/providers/movies_provider.dart';
import 'package:lati_marvel/screens/auth_screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BaseProvider>(
            create: (context) => BaseProvider()),
        ChangeNotifierProvider<MoviesProvider>(
            create: (context) => MoviesProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Marvel',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true),
          ),
          home: SplashScreen()),
    );
  }
}
