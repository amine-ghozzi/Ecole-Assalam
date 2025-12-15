import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/app_router.dart';
import 'providers/niveau_provider.dart';
import 'providers/groupe_provider.dart';
import 'providers/eleve_provider.dart';
import 'providers/horaire_provider.dart';
import 'providers/examen_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NiveauProvider()),
        ChangeNotifierProvider(create: (_) => GroupeProvider()),
        ChangeNotifierProvider(create: (_) => EleveProvider()),
        ChangeNotifierProvider(create: (_) => HoraireProvider()),
        ChangeNotifierProvider(create: (_) => ExamenProvider()),
      ],
      child: MaterialApp.router(
        title: 'École Assalam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            primary: const Color(0xFF2E7D32),
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
