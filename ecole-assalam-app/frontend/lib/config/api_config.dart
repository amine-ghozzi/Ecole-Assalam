class ApiConfig {
  // URL de base de l'API
  // Pour Android Emulator: http://10.0.2.2:3000
  // Pour iOS Simulator: http://localhost:3000
  // Pour Web: http://localhost:3000
  // Pour Production: https://votre-api.com

  static const String baseUrl = 'http://localhost:3000/api';

  // Endpoints
  static const String niveauxEndpoint = '/niveaux';
  static const String groupesEndpoint = '/groupes';
  static const String elevesEndpoint = '/eleves';
  static const String horairesEndpoint = '/horaires';
  static const String examensEndpoint = '/examens';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
