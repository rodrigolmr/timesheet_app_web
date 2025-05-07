class AppRoutes {
  // Paths (usados em redirecionamentos e URLs)
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/';
  static const String workers = '/workers';
  
  // Route names (usados na navegação por nome)
  static const String homeName = 'home';
  static const String loginName = 'login';
  static const String workersName = 'workers';
  
  // Métodos helpers para navegação
  static String workerDetails(String id) => '/workers/$id';
}
