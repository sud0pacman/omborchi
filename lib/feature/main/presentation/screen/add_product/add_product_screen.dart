import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omborchi/core/custom/formatters/thousand_formatter.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/custom/widgets/custom_text_field.dart';
import 'package:omborchi/core/custom/widgets/floating_action_button.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/presentation/bloc/add_product/add_product_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/pick_image.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final AddProductBloc _bloc = serviceLocator<AddProductBloc>();
  XFile? image;
  final imagePicker = ImagePicker();
  final items = ["skoch", "tosh"];
  final List<Widget> rawMaterialsWidget = [];

  @override
  void initState() {
    super.initState();

    rawMaterialsWidget.add(addRawMaterialItem());

    _bloc.add(GetCategories());

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<AddProductBloc, AddProductState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: simpleAppBar(
                leadingIcon: AssetRes.icBack,
                onTapLeading: () {},
                title: "Maxsulot qo'shish".tr),
            body: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(
                  height: 56,
                ),
                Center(
                  child: PickedImage(
                    image: image,
                    onTap: () async {
                      image = await imagePicker.pickImage(
                          source: ImageSource.gallery, imageQuality: 50);

                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                dropDownWithTitle(
                  "Kategoriya".tr,
                  CustomDropdownButton2(
                    hint: "test",
                    value: null,
                    dropdownItems: state.categories.map((e) => e.name).toList(),
                    itemColor: AppColors.background,
                    buttonColor: AppColors.white,
                    buttonTextStyle: medium.copyWith(fontSize: 16),
                    itemTextStyle: medium.copyWith(fontSize: 16),
                    onChanged: (value) {},
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),
                // rawMaterialItem(context)
                for (int i = 0; i < rawMaterialsWidget.length; i++)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      rawMaterialsWidget[i],
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),

                curdRawMaterialButtons(onTapPlus: () {
                  setState(() {
                    rawMaterialsWidget.add(addRawMaterialItem());
                  });
                }, onTapMinus: () {
                  setState(() {
                    rawMaterialsWidget.removeLast();
                  });
                }),

                const SizedBox(
                  height: 36,
                )
              ],
            )),
          );
        },
      ),
    );
  }

  Widget curdRawMaterialButtons(
      {required VoidCallback onTapPlus, required VoidCallback onTapMinus}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Row(
        children: [
          const Spacer(),
          primaryFloatingActionButton(onTap: onTapMinus, icon: Icons.remove),
          const SizedBox(
            width: 8,
          ),
          primaryFloatingActionButton(onTap: onTapPlus),
        ],
      ),
    );
  }

  Widget addRawMaterialItem() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(32)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropdownButton2(
                hint: items[0],
                value: items[0],
                dropdownItems: items,
                itemColor: AppColors.background,
                buttonColor: AppColors.white,
                buttonTextStyle: medium.copyWith(fontSize: 16),
                itemTextStyle: medium.copyWith(fontSize: 16),
                onChanged: (value) {},
              ),
              CustomDropdownButton2(
                hint: items[0],
                value: items[0],
                dropdownItems: items,
                itemColor: AppColors.background,
                buttonColor: AppColors.white,
                buttonTextStyle: medium.copyWith(fontSize: 16),
                itemTextStyle: medium.copyWith(fontSize: 16),
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          TextWithTextFieldSmokeWhiteWidget(
            controller: TextEditingController(),
            textInputType: TextInputType.number,
            inputFormatters: [ThousandsSeparatorInputFormatter()],
            title: "Narxi".tr,
            hint: "0",
          )
        ],
      ),
    );
  }

  Widget dropDownWithTitle(String title, Widget dropdown) {
    return Column(
      children: [
        Text(
          title,
          style: medium.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        dropdown
      ],
    );
  }
}

class CustomDropdownButton2 extends StatelessWidget {
  const CustomDropdownButton2({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    this.buttonColor,
    this.itemColor,
    this.buttonTextStyle,
    this.itemTextStyle,
    super.key,
  });

  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;
  final Color? buttonColor;
  final Color? itemColor;
  final TextStyle? buttonTextStyle;
  final TextStyle? itemTextStyle;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: AppColors.primary,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Container(
            alignment: hintAlignment,
            child: Text(
              hint,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          value: value,
          items: dropdownItems
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      alignment: valueAlignment,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: buttonTextStyle,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          selectedItemBuilder: selectedItemBuilder,
          buttonStyleData: ButtonStyleData(
            height: buttonHeight ?? 40,
            width: buttonWidth ?? 140,
            padding:
                buttonPadding ?? const EdgeInsets.only(left: 14, right: 14),
            decoration: buttonDecoration ??
                BoxDecoration(
                  color: buttonColor, // Change background color to yellow
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black45,
                  ),
                ),
            elevation: buttonElevation,
          ),
          iconStyleData: IconStyleData(
            icon: icon ?? const Icon(Icons.arrow_forward_ios_outlined),
            iconSize: iconSize ?? 12,
            iconEnabledColor: iconEnabledColor,
            iconDisabledColor: iconDisabledColor,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: dropdownHeight ?? 200,
            width: dropdownWidth ?? 140,
            padding: dropdownPadding,
            decoration: dropdownDecoration ??
                BoxDecoration(
                  color: itemColor,
                  borderRadius: BorderRadius.circular(14),
                ),
            elevation: dropdownElevation ?? 8,
            offset: offset,
            scrollbarTheme: ScrollbarThemeData(
              radius: scrollbarRadius ?? const Radius.circular(40),
              thickness: scrollbarThickness != null
                  ? WidgetStateProperty.all<double>(scrollbarThickness!)
                  : null,
              thumbVisibility: scrollbarAlwaysShow != null
                  ? WidgetStateProperty.all<bool>(scrollbarAlwaysShow!)
                  : null,
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: itemHeight ?? 40,
            padding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
