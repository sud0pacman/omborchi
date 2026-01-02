import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:omborchi/core/network/network_state.dart' as Network;
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/product_remote_data_source.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RenameImagesMigrationScreen extends StatefulWidget {
  const RenameImagesMigrationScreen({Key? key}) : super(key: key);

  @override
  State<RenameImagesMigrationScreen> createState() => _RenameImagesMigrationScreenState();
}

class _RenameImagesMigrationScreenState extends State<RenameImagesMigrationScreen> {
  final IsarHelper isarHelper = IsarHelper();
  late final ProductRemoteDataSource remoteDataSource;
  final uuid = const Uuid();

  bool isLoading = false;
  double progress = 0.0;
  int totalProducts = 0;
  int processedProducts = 0;
  int renamedProducts = 0;
  String statusMessage = 'Tayyor';
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    remoteDataSource = ProductRemoteDataSourceImpl(Supabase.instance.client);
  }

  void addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
      if (logs.length > 100) logs.removeAt(0);
    });
    AppRes.logger.i(message);
  }

  String extractFileName(String path) {
    // Path dan faqat fayl nomini olish
    return path.split('/').last;
  }

  String getFileExtension(String fileName) {
    // Fayl kengaytmasini olish
    if (fileName.contains('.')) {
      return fileName.split('.').last;
    }
    return 'jpg'; // Default
  }

  Future<void> startRenaming() async {
    setState(() {
      isLoading = true;
      progress = 0.0;
      processedProducts = 0;
      renamedProducts = 0;
      logs.clear();
      statusMessage = 'Renaming boshlandi...';
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

      // 2. 2025 bilan boshlanuvchi rasmlarni filtrlash
      final productsToRename = localProducts.where((product) {
        if (product.pathOfPicture == null) return false;
        final fileName = extractFileName(product.pathOfPicture!);
        return fileName.isNotEmpty;
      }).toList();

      if (productsToRename.isEmpty) {
        addLog('2025 yoki 1761 bilan boshlanuvchi rasm topilmadi!');
        setState(() {
          statusMessage = 'O\'zgartirish kerak bo\'lgan rasm yo\'q';
          isLoading = false;
        });
        return;
      }

      addLog('${productsToRename.length} ta mahsulot o\'zgartiriladi');
      totalProducts = productsToRename.length;

      // 3. Har bir mahsulotni qayta ishlash
      for (int i = 0; i < productsToRename.length; i++) {
        final localProduct = productsToRename[i];

        try {
          addLog('Mahsulot ID ${localProduct.id} qayta ishlanmoqda...');

          final oldPath = localProduct.pathOfPicture!;
          final oldFileName = extractFileName(oldPath);
          final fileExtension = getFileExtension(oldFileName);

          addLog('ID ${localProduct.id}: Eski fayl: $oldFileName');

          // Local fayl mavjudligini tekshirish
          final oldFile = File(oldPath);
          if (!await oldFile.exists()) {
            addLog('ID ${localProduct.id}: Fayl topilmadi, o\'tkazib yuborildi');
            processedProducts++;
            updateProgress();
            continue;
          }

          // 4. UUID yaratish va yangi fayl nomi
          final newUuid = uuid.v4();
          final newFileName = '$newUuid.$fileExtension';

          // Yangi path (o'sha papkada)
          final directory = oldFile.parent.path;
          final newPath = '$directory/$newFileName';

          addLog('ID ${localProduct.id}: Yangi fayl: $newFileName');

          // 5. Faylni rename qilish (local)
          try {
            await oldFile.rename(newPath);
            addLog('ID ${localProduct.id}: Local fayl o\'zgartirildi ✓');
          } catch (e) {
            addLog('ID ${localProduct.id}: Faylni rename qilishda xatolik: $e');
            processedProducts++;
            updateProgress();
            continue;
          }

          // // 6. Cloudflare ga yangi nom bilan yuklash
          // addLog('ID ${localProduct.id}: Cloudflare ga yuklanyapti...');
          //
          // final uploadResult = await remoteDataSource.uploadImage(
          //   newFileName,
          //   newPath,
          // );
          //
          // if (uploadResult is! Network.Success) {
          //   addLog('ID ${localProduct.id}: Yuklashda xatolik: ${uploadResult.toString()}');
          //   // Faylni qaytarib rename qilish
          //   try {
          //     await File(newPath).rename(oldPath);
          //     addLog('ID ${localProduct.id}: Fayl qaytarildi');
          //   } catch (e) {
          //     addLog('ID ${localProduct.id}: Faylni qaytarishda xatolik: $e');
          //   }
          //   processedProducts++;
          //   updateProgress();
          //   continue;
          // }
          //
          // final cloudflareUrl = uploadResult.value as String;
          // addLog('ID ${localProduct.id}: Cloudflare URL: $cloudflareUrl');
          //
          // // 7. Supabase da path_of_picture ni yangilash
          // addLog('ID ${localProduct.id}: Supabase yangilanmoqda...');
          //
          // try {
          //   await Supabase.instance.client
          //       .from(ExpenseFields.productTable)
          //       .update({'path_of_picture': cloudflareUrl})
          //       .eq('id', localProduct.id);
          //
          //   addLog('ID ${localProduct.id}: Supabase yangilandi ✓');
          //
          //   // 8. Local Isar DB ni yangilash
          //   localProduct.pathOfPicture = newPath;
          //   await isarHelper.updateProduct(localProduct);
          //
          //   addLog('ID ${localProduct.id}: Local DB yangilandi ✓');
          //   addLog('ID ${localProduct.id}: MUVAFFAQIYATLI YAKUNLANDI! 🎉');
          //
          //   renamedProducts++;
          //
          // } catch (e) {
          //   addLog('ID ${localProduct.id}: Supabase da xatolik: $e');
          // }
          //
          // processedProducts++;
          // updateProgress();
          //
          // // Serverni ortiqcha yuklamaslik uchun biroz kutish
          // await Future.delayed(const Duration(milliseconds: 300));

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

      addLog('🎉 Jarayon yakunlandi: $renamedProducts/$totalProducts ta rasm o\'zgartirildi');

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
        title: const Text('Rename Images Migration'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 4,
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      statusMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (totalProducts > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Qayta ishlangan'),
                              Text(
                                '$processedProducts / $totalProducts',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('O\'zgartirilgan'),
                              Text(
                                '$renamedProducts',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress == 100 ? Colors.green : Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${progress.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
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
              onPressed: isLoading ? null : startRenaming,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(
                isLoading ? 'Jarayon davom etmoqda...' : 'Renamingni boshlash',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),

            // Logs Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Loglar:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (logs.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        logs.clear();
                      });
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Tozalash'),
                  ),
              ],
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
                  reverse: false,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    Color logColor = Colors.white;

                    if (log.contains('✓') || log.contains('🎉')) {
                      logColor = Colors.green;
                    } else if (log.contains('Xatolik') || log.contains('xatolik')) {
                      logColor = Colors.red;
                    } else if (log.contains('UUID') || log.contains('Yangi')) {
                      logColor = Colors.cyan;
                    } else if (log.contains('Cloudflare')) {
                      logColor = Colors.orange;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        log,
                        style: TextStyle(
                          color: logColor,
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