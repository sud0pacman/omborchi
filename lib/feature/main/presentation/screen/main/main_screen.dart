import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/custom/widgets/nav_bar.dart';
import 'package:omborchi/core/custom/widgets/primary_container.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/feature/main/presentation/bloc/main/main_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/add_product_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/category/category_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/main/widgets/category_widget.dart';
import 'package:omborchi/feature/main/presentation/screen/main/widgets/home_app_bar.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/raw_material_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material_type/raw_material_type_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainBloc _bloc = MainBloc(serviceLocator());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> screens = [
    const AddProductScreen(),
    const CategoryScreen(),
    const RawMaterialScreen(),
    const RawMaterialTypeScreen()
  ];

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
          onItemTapped: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, RouteManager.addProductScreen);
            }
            else if (index == 1) {
              Navigator.pushNamed(context, RouteManager.categoryScreen);
            }
            else if (index == 2) {
              Navigator.pushNamed(context, RouteManager.rawMaterialScreen);
            }
            else if (index == 3) {
              Navigator.pushNamed(context, RouteManager.rawMaterialTypeScreen);
            }

            _scaffoldKey.currentState?.closeDrawer();  
          },
        ),
        appBar: homeAppBar(onTapLeading: () {
          _scaffoldKey.currentState?.openDrawer();
        }),
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
