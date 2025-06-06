import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  final box = GetStorage();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final pinController = TextEditingController();

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = box.read('token');
    if (token != null) {
      final userData = box.read('user');
      if (userData != null) {
        currentUser.value = UserModel.fromJson(userData);
        Get.offAllNamed(Routes.HOME);
      }
    }
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Username dan password harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.login(
        usernameController.text,
        passwordController.text,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        box.write('token', data['token']);
        box.write('user', data['user']);
        currentUser.value = UserModel.fromJson(data['user']);

        if (rememberMe.value) {
          box.write('remember_username', usernameController.text);
        } else {
          box.remove('remember_username');
        }

        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Login Gagal',
          response.body['error'] ?? 'Username atau password salah',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithPIN(String username, String pin) async {
    isLoading.value = true;
    try {
      final response = await _authService.loginWithPIN(username, pin);

      if (response.statusCode == 200) {
        final data = response.body;
        box.write('token', data['token']);
        box.write('user', data['user']);
        currentUser.value = UserModel.fromJson(data['user']);
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Login Gagal',
          'PIN salah',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    box.remove('token');
    box.remove('user');
    currentUser.value = null;
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    pinController.dispose();
    super.onClose();
  }
}
