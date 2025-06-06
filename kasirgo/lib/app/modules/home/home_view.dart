import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/session_controller.dart';
import '../../routes/app_pages.dart';

class HomeView extends GetView<AuthController> {
  final SessionController sessionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KasirGo F&B'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(controller.currentUser.value?.fullName ?? ''),
                  subtitle: Text(controller.currentUser.value?.role ?? ''),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                controller.logout();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Session Status
          Obx(() => Container(
                padding: const EdgeInsets.all(16),
                color: sessionController.activeSession.value != null
                    ? Colors.green[50]
                    : Colors.orange[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sessionController.activeSession.value != null
                              ? 'Sesi Aktif'
                              : 'Tidak Ada Sesi Aktif',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: sessionController.activeSession.value != null
                                ? Colors.green[800]
                                : Colors.orange[800],
                          ),
                        ),
                        if (sessionController.activeSession.value != null)
                          Text(
                            'Modal: Rp ${sessionController.activeSession.value!.startCash?.toStringAsFixed(0) ?? '0'}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                      ],
                    ),
                    if (sessionController.activeSession.value == null)
                      ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.START_SESSION),
                        child: const Text('Mulai Sesi'),
                      )
                    else
                      OutlinedButton(
                        onPressed: () => Get.toNamed(Routes.CLOSE_SESSION),
                        child: const Text('Tutup Sesi'),
                      ),
                  ],
                ),
              )),

          // Menu Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.shopping_cart,
                  title: 'Kasir',
                  subtitle: 'Buat transaksi baru',
                  color: Colors.blue,
                  onTap: () {
                    if (sessionController.activeSession.value == null) {
                      Get.snackbar(
                        'Perhatian',
                        'Silakan mulai sesi terlebih dahulu',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    Get.toNamed(Routes.POS);
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.history,
                  title: 'Riwayat',
                  subtitle: 'Lihat transaksi hari ini',
                  color: Colors.green,
                  onTap: () => Get.toNamed(Routes.TRANSACTION_HISTORY),
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.inventory,
                  title: 'Produk',
                  subtitle: 'Kelola produk',
                  color: Colors.orange,
                  onTap: () {
                    Get.snackbar('Info', 'Fitur dalam pengembangan');
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.assessment,
                  title: 'Laporan',
                  subtitle: 'Lihat laporan penjualan',
                  color: Colors.purple,
                  onTap: () {
                    Get.snackbar('Info', 'Fitur dalam pengembangan');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
