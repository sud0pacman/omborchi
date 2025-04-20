import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/widgets/primary_button.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/feature/main/presentation/bloc/sync/sync_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../../core/custom/widgets/app_bar.dart';
import '../../../../../core/utils/consants.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final SyncBloc _bloc = SyncBloc(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator());
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSyncDialogOpen = false;
  String? currentRepository;

  double? syncProgress;

  int? currentRepositoryIndex;

  String? tempError;

  void showSyncProgressDialog(BuildContext context) {
    if (!isSyncDialogOpen) {
      isSyncDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false, // Prevents back button from dismissing the dialog
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<SyncBloc, SyncState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${state.currentRepository ?? ''} sinxronlanmoqda... "
                          "(${state.currentRepositoryIndex ?? 0}/5)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Assuming pmedium
                            color: context.textColor(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          backgroundColor: AppColors.paleBlue,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                          value: (state.syncProgress ?? 0) / 100,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${state.syncProgress?.toInt() ?? 0}%",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Assuming pmedium
                            color: context.textColor(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void hideSyncProgressDialog(BuildContext context) {
    if (isSyncDialogOpen) {
      isSyncDialogOpen = false;
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar(
        context,
        title: "Ma'lumotlarni Sinxronlash",
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<SyncBloc, SyncState>(
          listener: (context, state) {
            if (state.currentRepository != null ||
                state.syncProgress != null ||
                state.currentRepositoryIndex != null) {
              setState(() {
                currentRepository = state.currentRepository;
                syncProgress = state.syncProgress;

                currentRepositoryIndex = state.currentRepositoryIndex;
              }); // Trigger UI rebuild if loading state changes
            }
            if (state.error != null) {
              if (tempError == state.error!) {
              } else {
                AppRes.showSnackBar(context,message:  state.error!, isErrorMessage: true);
                tempError = state.error;
              }
            }
            if (state.isLoading) {
              showSyncProgressDialog(context);
            } else {
              hideSyncProgressDialog(context);
            }
            if (state.isSuccess) {
              Navigator.pushReplacementNamed(
                  context, RouteManager.mainScreen); // MainScreen'ga o'tish
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Icon(
                            CupertinoIcons.cloud_download_fill,
                            size: 142,
                            color: AppColors.primary,
                          ),
                        ),
                        24.verticalSpace,
                        Text(
                          "Ma'lumotlar yangilanishi uchun internet yaxshi ishlayotganini tekshiring. Ko'chirib olish tugaguncha bu oynani yopmang.",
                          style: medium.copyWith(
                              fontSize: 16, color: context.textColor()),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    width: double.infinity,
                    text: "Ko'chirishni boshlash",
                    onPressed: () {
                      _bloc.add(SyncGetDataEvent());
                    },
                  ),
                  8.verticalSpace
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
