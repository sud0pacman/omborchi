import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/custom/widgets/loading_dialog.dart';
import 'package:omborchi/core/custom/widgets/primary_button.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/feature/main/presentation/bloc/sync/sync_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
          return BlocBuilder<SyncBloc, SyncState>(
            bloc: _bloc,
            builder: (context, state) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${state.currentRepository ?? ''} sinxronlanmoqda... "
                        "(${state.currentRepositoryIndex ?? 0}/5)",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          "Ma'lumotlarni Sinxronlash",
          style: boldWhite.copyWith(fontSize: 18),
        ),
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
                AppRes.showSnackBar(context, state.error!);
                tempError = state.error;
              }
            }
            if (state.isLoading) {
              showSyncProgressDialog(context);
            } else {
              hideSyncProgressDialog(context);
            }
            if (state.isLoading) {
              showLoadingDialog(context);
            } else if (state.isSuccess) {
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
                        Center(
                          child: Container(
                            color: AppColors.background,
                            // Lottie background color
                            child: Lottie.asset(
                              height: 172,
                              'assets/lottie/cloud.json',
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Ma'lumotlar yangilanishi uchun internet yaxshi ishlayotganini tekshiring. Ko'chirib olish tugaguncha bu oynani yopmang.",
                          style: medium.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    height: 48,
                    width: double.infinity,
                    title: "Ko'chirishni boshlash",
                    onPressed: () {
                      _bloc.add(SyncGetDataEvent());
                    },
                  ),
                  const SizedBox(
                    height: 56,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
