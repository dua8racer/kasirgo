import 'package:get/get.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  Future<Response> login(String username, String password) async {
    return await post('/auth/login', {
      'username': username,
      'password': password,
    });
  }

  Future<Response> loginWithPIN(String username, String pin) async {
    return await post('/auth/login', {
      'username': username,
      'pin': pin,
    });
  }
}
