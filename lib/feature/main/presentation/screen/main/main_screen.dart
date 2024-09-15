import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omborchi/core/custom/widgets/nav_bar.dart';
import 'package:omborchi/core/custom/widgets/primary_container.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/presentation/bloc/main/main_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/main/widgets/category_widget.dart';
import 'package:omborchi/feature/main/presentation/screen/main/widgets/home_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainBloc _bloc = MainBloc(serviceLocator());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc.add(GetCategories());
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: PrimaryNavbar(
          selectedIndex: 0,
          onItemTapped: (index) {},
        ),
        appBar: homeAppBar(
          onTapLeading: () {
            _scaffoldKey.currentState?.openDrawer();
          }
        ),
        body: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return PrimaryContainer(
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return CategoryWidget(
                          onTap: () {},
                          isActive: index == 0,
                          name: 'общий',
                          count: 826,
                        );
                      },
                      itemCount: 10,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
