import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/niveaux/niveaux_list_screen.dart';
import '../screens/niveaux/niveau_form_screen.dart';
import '../screens/groupes/groupes_list_screen.dart';
import '../screens/groupes/groupe_form_screen.dart';
import '../screens/eleves/eleves_list_screen.dart';
import '../screens/eleves/eleve_form_screen.dart';
import '../screens/examens/examens_list_screen.dart';
import '../screens/examens/examen_form_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/niveaux',
      builder: (context, state) => const NiveauxListScreen(),
    ),
    GoRoute(
      path: '/niveaux/new',
      builder: (context, state) => const NiveauFormScreen(),
    ),
    GoRoute(
      path: '/niveaux/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return NiveauFormScreen(niveauId: id);
      },
    ),
    GoRoute(
      path: '/groupes',
      builder: (context, state) => const GroupesListScreen(),
    ),
    GoRoute(
      path: '/groupes/new',
      builder: (context, state) => const GroupeFormScreen(),
    ),
    GoRoute(
      path: '/groupes/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return GroupeFormScreen(groupeId: id);
      },
    ),
    GoRoute(
      path: '/eleves',
      builder: (context, state) => const ElevesListScreen(),
    ),
    GoRoute(
      path: '/eleves/new',
      builder: (context, state) => const EleveFormScreen(),
    ),
    GoRoute(
      path: '/eleves/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return EleveFormScreen(eleveId: id);
      },
    ),
    GoRoute(
      path: '/examens',
      builder: (context, state) => const ExamensListScreen(),
    ),
    GoRoute(
      path: '/examens/new',
      builder: (context, state) => const ExamenFormScreen(),
    ),
    GoRoute(
      path: '/examens/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ExamenFormScreen(examenId: id);
      },
    ),
  ],
);
