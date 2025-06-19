class ApiConstants {
  // ⚠️ CONFIGURAÇÃO NECESSÁRIA: Altere esta URL para o endereço da sua API Java
  // Exemplo: 'http://localhost:8080/api' ou 'http://192.168.1.100:8080/api'
  static const String baseUrl = 'http://SEU_IP_AQUI:8080/api';
  
  // Endpoints da API Java - AJUSTE CONFORME SUA IMPLEMENTAÇÃO
  static const String loginEndpoint = '/auth/login';
  static const String studentsEndpoint = '/students';
  static const String answersEndpoint = '/answers';
  static const String examsEndpoint = '/exams';
  
  // Headers padrão
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Chaves para SharedPreferences
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userRoleKey = 'user_role';
  static const String isLoggedInKey = 'is_logged_in';
}

class AppStrings {
  static const String appName = 'Correção de Gabaritos';
  static const String loginTitle = 'Login';
  static const String username = 'Usuário';
  static const String password = 'Senha';
  static const String login = 'Entrar';
  static const String selectStudent = 'Selecionar Aluno';
  static const String inputAnswers = 'Inserir Respostas';
  static const String submit = 'Enviar';
  static const String logout = 'Sair';
}

