import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService extends GetConnect {
  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = 'http://192.168.2.16:8080/api/v1';
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      final token = box.read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      print('Request: ${request.url}');
      print('Response: ${response.statusCode}');
      return response;
    });

    super.onInit();
  }
}
