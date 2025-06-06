import 'package:get/get.dart';
import 'api_service.dart';

class SessionService extends ApiService {
  Future<Response> startSession(double startCash) async {
    return await post('/sessions/start', {
      'start_cash': startCash,
    });
  }

  Future<Response> getActiveSession() async {
    return await get('/sessions/active');
  }

  Future<Response> closeSession(
      String sessionId, double endCash, String notes) async {
    return await post('/sessions/$sessionId/close', {
      'end_cash': endCash,
      'notes': notes,
    });
  }
}
