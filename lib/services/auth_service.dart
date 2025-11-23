class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Map<String, String> _users = {
    'admin@teste.com': '123456',
  };

  final Map<String, String> _userDetails = {
    'admin@teste.com': 'Administrador',
  };

  bool register(String name, String email, String password) {
    if (_users.containsKey(email)) {
      return false;
    }
    _users[email] = password;
    _userDetails[email] = name;
    return true;
  }

  bool login(String email, String password) {
    if (_users.containsKey(email) && _users[email] == password) {
      return true;
    }
    return false;
  }

  String? getName(String email) {
    return _userDetails[email];
  }

  bool emailExists(String email) {
    return _users.containsKey(email);
  }
}

final authService = AuthService();
