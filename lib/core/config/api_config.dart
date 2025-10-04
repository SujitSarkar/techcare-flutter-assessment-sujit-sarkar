class ApiConfig {
  ApiConfig._();

  // Base URL
  static const String baseUrl = 'https://cb500dad-fbca-4ad4-b4cd-a75bc5ec5f22.mock.pstmn.io/api';

  // API Endpoints
  static const String categoriesEndpoint = 'categories';

  // Full URLs
  static String get categoriesUrl => '$baseUrl/$categoriesEndpoint';
}
