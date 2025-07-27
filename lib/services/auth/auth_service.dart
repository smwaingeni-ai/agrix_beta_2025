// lib/services/auth/auth_service.dart

class AuthService {
  static final List<Map<String, String>> dummyUsers = [
    {'role': 'Farmer', 'name': 'demo', 'passcode': '123456'},
    {'role': 'Officer', 'name': 'officer1', 'passcode': 'pass123'},
    {'role': 'Investor', 'name': 'investor1', 'passcode': 'invest123'},
  ];

  static bool authenticate(String role, String name, String passcode) {
    return dummyUsers.any((user) =>
      user['role'] == role &&
      user['name'] == name &&
      user['passcode'] == passcode
    );
  }
}
