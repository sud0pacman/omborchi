import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:omborchi/core/custom/widgets/floating_action_button.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/widgets/raw_material_item.dart';

class RawMaterailPage extends StatelessWidget {
  final List<RawMaterial> listRawMaterials;
  final VoidCallback onTapFloatingAction;
  final Function(RawMaterial rawMaterial) onEdit;
  final Function(RawMaterial rawMaterial) onDelete;

  const RawMaterailPage({
    super.key,
    required this.listRawMaterials,
    required this.onTapFloatingAction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          primaryFloatingActionButton(onTap: onTapFloatingAction),
      body: listRawMaterials.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              itemCount: listRawMaterials.length,
              itemBuilder: (context, index) {
                return RawMaterialItem(
                  name: listRawMaterials[index].name!,
                  price: listRawMaterials[index].price.toString(),
                  onTapEdit: () => onEdit(listRawMaterials[index]),
                  onTapDelete: () => onDelete(listRawMaterials[index]),
                );
              },
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: AppColors.steelGrey.withOpacity(0.2),
              ),
            )
          : Center(
              child: Lottie.asset(
                'assets/lottie/empty.json',
                // Load the Lottie animation for empty state
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
