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

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final SyncBloc _bloc = SyncBloc(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            if (state.isLoading) {
              showLoadingDialog(context);
            } else if (state.isSuccess) {
              Navigator.pushReplacementNamed(context, RouteManager.mainScreen); // MainScreen'ga o'tish
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
