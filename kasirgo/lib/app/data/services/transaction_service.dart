import 'package:get/get.dart';
import 'api_service.dart';

class TransactionService extends ApiService {
  Future<Response> createTransaction(Map<String, dynamic> data) async {
    return await post('/transactions', data);
  }

  Future<Response> getTransaction(String id) async {
    return await get('/transactions/$id');
  }

  Future<Response> getTransactionsBySession(String sessionId) async {
    return await get('/sessions/$sessionId/transactions');
  }

  Future<Response> getTransactionsByDateRange(
      String startDate, String endDate) async {
    return await get('/transactions?start_date=$startDate&end_date=$endDate');
  }
}
