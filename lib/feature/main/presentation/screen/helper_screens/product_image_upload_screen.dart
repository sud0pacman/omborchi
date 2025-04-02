import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/widgets/primary_button.dart';
import 'package:omborchi/core/custom/widgets/under_save_button.dart';
import 'package:omborchi/core/network/network_state.dart' as NetworkState;
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/product_remote_data_source.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageStorageScreen extends StatefulWidget {
  const ImageStorageScreen({super.key});

  @override
  State<ImageStorageScreen> createState() => _ImageStorageScreenState();
}

class _ImageStorageScreenState extends State<ImageStorageScreen> {
  List<FileSystemEntity> _imageFiles = [];
  double _uploadProgress = 0.0;
  bool _isLoading = false;
  bool _permissionGranted = false;
  final ProductRemoteDataSource _remoteDataSource = ProductRemoteDataSourceImpl(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoad();
  }

  Future<void> _requestPermissionAndLoad() async {
    setState(() => _isLoading = true);

    PermissionStatus status;
    if (Platform.isAndroid && (await _getAndroidVersion()) >= 13) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      setState(() => _permissionGranted = true);
      await _loadImages();
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Ruxsat berilmadi. Iltimos, sozlamalardan ruxsat bering.",
            style: pregular.copyWith(color: AppColors.white),
          ),
          action: SnackBarAction(
            label: "Sozlamalar",
            onPressed: openAppSettings,
          ),
        ),
      );
      setState(() => _permissionGranted = false);
    } else {
      setState(() => _permissionGranted = false);
    }
    setState(() => _isLoading = false);
  }

  Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    }
    return 0;
  }

  Future<void> _loadImages() async {
    setState(() => _isLoading = true);
    try {
      final directory = Directory('/storage/emulated/0/Download/images');
      if (await directory.exists()) {
        final files = directory.listSync();
        _imageFiles = files
            .where((file) => file.path.endsWith('.jpg') || file.path.endsWith('.png'))
            .toList();
        setState(() => _uploadProgress = 0.0);
      } else {
        _imageFiles = [];
      }
    } catch (e) {
      AppRes.logger.e("Rasmlarni yuklashda xatolik: $e");
      _imageFiles = [];
    }
    setState(() => _isLoading = false);
  }

  Future<void> _uploadImagesToSupabase() async {
    if (_imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Yuklash uchun rasmlar topilmadi", style: pregular.copyWith(color: AppColors.white)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    int uploadedCount = 0;

    for (int i = 0; i < _imageFiles.length; i++) {
      final file = _imageFiles[i] as File;
      final fileName = file.path.split('/').last;

      final result = await _remoteDataSource.uploadImage(fileName, file.path);
      if (result is NetworkState.Success) {
        uploadedCount++;
        final progress = (uploadedCount / _imageFiles.length) * 100;
        setState(() => _uploadProgress = progress);
        AppRes.logger.i("$fileName muvaffaqiyatli yuklandi: ${result.value}");
      } else if (result is NetworkState.NoInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internet aloqasi yo'q", style: pregular.copyWith(color: AppColors.white)),
          ),
        );
        break;
      } else {
        AppRes.logger.e("Yuklashda xatolik: ${result.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$fileName yuklanmadi", style: pregular.copyWith(color: AppColors.white)),
          ),
        );
      }
    }

    setState(() => _isLoading = false);
    if (uploadedCount == _imageFiles.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Barcha rasmlar yuklandi", style: pregular.copyWith(color: AppColors.white)),
        ),
      );
    }
  }

  void _showImageDetails(BuildContext context, FileSystemEntity file) {
    final fileStat = file.statSync();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fayl ma'lumotlari", style: pmedium.copyWith(fontSize: 18.sp, color: context.textColor())),
            SizedBox(height: 16.h),
            Text("Nomi: ${file.path.split('/').last}", style: pregular.copyWith(fontSize: 16.sp)),
            Text("Hajmi: ${(fileStat.size / 1024 / 1024).toStringAsFixed(2)} MB", style: pregular.copyWith(fontSize: 16.sp)),
            Text("Joylashuvi: ${file.path}", style: pregular.copyWith(fontSize: 16.sp)),
            Text("Yaratilgan: ${fileStat.changed.toString()}", style: pregular.copyWith(fontSize: 16.sp)),
            Text("Oxirgi o'zgartirilgan: ${fileStat.modified.toString()}", style: pregular.copyWith(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text("Rasm ko'rish", style: pmedium.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.primary,
          ),
          body: Center(
            child: Image.file(file, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rasmlar ombori", style: pmedium.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_isLoading || _uploadProgress > 0)
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _uploadProgress / 100,
                        backgroundColor: AppColors.paleBlue,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Yuklanmoqda: ${_uploadProgress.toStringAsFixed(1)}%",
                        style: pregular.copyWith(fontSize: 16.sp, color: context.textColor()),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _permissionGranted && _imageFiles.isNotEmpty
                    ? ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: _imageFiles.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final file = _imageFiles[index] as File;
                    final fileStat = file.statSync();
                    return InkWell(
                      onTap: () => _showImagePreview(context, file),
                      child: Container(
                        decoration: containerBoxDecoration.copyWith(
                          borderRadius: BorderRadius.circular(14.r),
                          color: context.containerColor(),
                        ),
                        child: ListTile(
                          leading: SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: Image.file(file, fit: BoxFit.cover),
                          ),
                          title: Text(
                            file.path.split('/').last,
                            style: pmedium.copyWith(fontSize: 16.sp, color: context.textColor()),
                          ),
                          subtitle: Text(
                            "${(fileStat.size / 1024 / 1024).toStringAsFixed(2)} MB",
                            style: pregular.copyWith(fontSize: 14.sp, color: context.textColor().withOpacity(0.7)),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert, color: AppColors.primary),
                            onPressed: () => _showImageDetails(context, file),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _permissionGranted ? "Fayl topilmadi" : "Ruxsat berilmagan",
                        style: pmedium.copyWith(fontSize: 18.sp, color: context.textColor()),
                      ),
                      SizedBox(height: 16.h),
                      PrimaryButton(
                        text: "Qayta tekshirish",
                        height: 48.h,
                        width: 200.w,
                        onPressed: _requestPermissionAndLoad,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_imageFiles.isNotEmpty)
            UnderSaveButton(
              title: "Yuklash",
              onPressed: _uploadImagesToSupabase,
            ),
        ],
      ),
    );
  }
}