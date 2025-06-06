import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService extends GetConnect {
  final box = GetStorage();

  @override
  void onInit() {
    // IMPORTANT: Change this to your actual backend URL
    // For Android Emulator use: http://10.0.2.2:8080
    // For iOS Simulator use: http://localhost:8080
    // For Physical Device use: http://YOUR_COMPUTER_IP:8080
    httpClient.baseUrl = 'http://192.168.2.16:8080/api/v1';

    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 30);

    // Add auth header
    httpClient.addRequestModifier<dynamic>((request) {
      final token = box.read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // Log requests
    httpClient.addRequestModifier<dynamic>((request) {
      print('🚀 ${request.method} ${request.url}');
      return request;
    });

    // Log responses
    httpClient.addResponseModifier<dynamic>((request, response) {
      print('✅ Response: ${response.statusCode}');
      return response;
    });

    super.onInit();
  }
}
