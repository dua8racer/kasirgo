import 'package:get/get.dart';
import '../data/models/session_model.dart';
import '../data/services/session_service.dart';

class SessionController extends GetxController {
  final SessionService _sessionService = Get.put(SessionService());

  final isLoading = false.obs;
  final activeSession = Rx<SessionModel?>(null);

  @override
  void onInit() {
    super.onInit();
    checkActiveSession();
  }

  Future<void> checkActiveSession() async {
    isLoading.value = true;
    try {
      final response = await _sessionService.getActiveSession();
      if (response.statusCode == 200) {
        activeSession.value = SessionModel.fromJson(response.body);
      }
    } catch (e) {
      print('No active session: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startSession(double startCash) async {
    isLoading.value = true;
    try {
      final response = await _sessionService.startSession(startCash);
      if (response.statusCode == 201) {
        activeSession.value = SessionModel.fromJson(response.body);
        Get.back();
        Get.snackbar(
          'Berhasil',
          'Sesi kasir berhasil dimulai',
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar('Error', response.body['error'] ?? 'Gagal memulai sesi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> closeSession(double endCash, String notes) async {
    if (activeSession.value == null) return;

    isLoading.value = true;
    try {
      final response = await _sessionService.closeSession(
        activeSession.value!.id!,
        endCash,
        notes,
      );

      if (response.statusCode == 200) {
        activeSession.value = null;
        Get.back();
        Get.snackbar(
          'Berhasil',
          'Sesi kasir berhasil ditutup',
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );

        // Show session report
        Get.toNamed('/session-report', arguments: response.body);
      } else {
        Get.snackbar('Error', response.body['error'] ?? 'Gagal menutup sesi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
