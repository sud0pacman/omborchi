import 'dart:io';

import 'package:flutter/material.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart' as NetworkState;
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/product_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/modules/app_module.dart';

class MigrationToCloudflareScreen extends StatefulWidget {
  const MigrationToCloudflareScreen({Key? key}) : super(key: key);

  @override
  State<MigrationToCloudflareScreen> createState() =>
      _MigrationToCloudflareScreenState();
}

class _MigrationToCloudflareScreenState
    extends State<MigrationToCloudflareScreen> {
  final IsarHelper isarHelper = IsarHelper();
  late final ProductRemoteDataSource remoteDataSource;

  bool isLoading = false;
  double progress = 0.0;
  int totalProducts = 0;
  int processedProducts = 0;
  String statusMessage = 'Tayyor';
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    remoteDataSource = ProductRemoteDataSourceImpl(serviceLocator());
  }

  void addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
      if (logs.length > 50) logs.removeAt(0);
    });
    AppRes.logger.i(message);
  }

  Future<void> startMigration() async {
    setState(() {
      isLoading = true;
      progress = 0.0;
      processedProducts = 0;
      logs.clear();
      statusMessage = 'Migration boshlandi...';
    });

    try {
      addLog('Local mahsulotlar yuklanmoqda...');

      // 1. Local mahsulotlarni olish
      final localProducts = await isarHelper.getAllProducts();
      totalProducts = localProducts.length;

      if (totalProducts == 0) {
        addLog('Hech qanday mahsulot topilmadi!');
        setState(() {
          statusMessage = 'Migration yakunlandi: 0 mahsulot';
          isLoading = false;
        });
        return;
      }

      addLog('Jami $totalProducts ta mahsulot topildi');

      // 2. Har bir mahsulotni qayta ishlash
      for (int i = 0; i < 2; i++) {
        final localProduct = localProducts[i];

        try {
          addLog('Mahsulot ID ${localProduct.id} qayta ishlanmoqda...');

          // Local rasmni tekshirish
          if (localProduct.pathOfPicture == null ||
              !localProduct.pathOfPicture!.startsWith('/data')) {
            addLog(
                'ID ${localProduct.id}: Noto\'g\'ri rasm yo\'li, o\'tkazib yuborildi');
            processedProducts++;
            updateProgress();
            continue;
          }

          final localImageFile = File(localProduct.pathOfPicture!);

          if (!await localImageFile.exists()) {
            addLog(
                'ID ${localProduct.id}: Fayl topilmadi: ${localProduct.pathOfPicture}');
            processedProducts++;
            updateProgress();
            continue;
          }

          // 3. Cloudflare ga rasm yuklash
          final imageName =
              'product_${localProduct.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          addLog('ID ${localProduct.id}: Cloudflare ga yuklanyapti...');

          final uploadResult = await remoteDataSource.uploadImage(
            imageName,
            localProduct.pathOfPicture!,
          );

          if (uploadResult is! NetworkState.Success) {
            addLog(
                'ID ${localProduct.id}: Yuklashda xatolik: ${uploadResult.toString()}');
            processedProducts++;
            updateProgress();
            continue;
          }

          final cloudflareUrl = uploadResult.value as String;
          addLog('ID ${localProduct.id}: Cloudflare URL: $cloudflareUrl');

          // 4. Supabase da path_of_picture ni yangilash
          addLog('ID ${localProduct.id}: Supabase yangilanmoqda...');

          try {
            await Supabase.instance.client
                .from(ExpenseFields.productTable)
                .update({'path_of_picture': cloudflareUrl}).eq(
                    'id', localProduct.id);

            addLog('ID ${localProduct.id}: Muvaffaqiyatli yangilandi! ✓');
          } catch (e) {
            addLog('ID ${localProduct.id}: Supabase da xatolik: $e');
          }

          processedProducts++;
          updateProgress();

          // Serverni ortiqcha yuklamaslik uchun biroz kutish
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          addLog('ID ${localProduct.id}: Xatolik yuz berdi: $e');
          processedProducts++;
          updateProgress();
        }
      }

      setState(() {
        statusMessage = 'Migration muvaffaqiyatli yakunlandi!';
        isLoading = false;
      });

      addLog(
          '🎉 Barcha jarayonlar yakunlandi: $processedProducts/$totalProducts');
    } catch (e) {
      addLog('Umumiy xatolik: $e');
      setState(() {
        statusMessage = 'Xatolik yuz berdi!';
        isLoading = false;
      });
    }
  }

  void updateProgress() {
    setState(() {
      progress = (processedProducts / totalProducts) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloudflare Migration'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      statusMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (totalProducts > 0) ...[
                      Text(
                        '$processedProducts / $totalProducts mahsulot',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress == 100 ? Colors.green : Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${progress.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Start Button
            ElevatedButton(
              onPressed: isLoading ? null : startMigration,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(
                isLoading ? 'Jarayon davom etmoqda...' : 'Migrationni boshlash',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),

            // Logs Section
            const Text(
              'Loglar:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: logs.isEmpty
                    ? const Center(
                        child: Text(
                          'Loglar bu yerda ko\'rinadi',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              logs[index],
                              style: TextStyle(
                                color: logs[index].contains('✓')
                                    ? Colors.green
                                    : logs[index].contains('Xatolik') ||
                                            logs[index].contains('xatolik')
                                        ? Colors.red
                                        : Colors.white,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
