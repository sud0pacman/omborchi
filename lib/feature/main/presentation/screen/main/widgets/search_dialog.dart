import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';

import '../../../../../../core/theme/style_res.dart'; // Ensure to use your AppColors and styles

class SearchDialog extends StatefulWidget {
  final Function(String nomer, String eni, String boyi, String narxi,
      String marja, CategoryModel? category) onSearchTap;
  final List<CategoryModel> categoryList;

  const SearchDialog(
      {super.key, required this.onSearchTap, required this.categoryList});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _nomerDanController = TextEditingController();
  final TextEditingController _nomerGachaController = TextEditingController();
  final TextEditingController _eniDanController = TextEditingController();
  final TextEditingController _eniGachaController = TextEditingController();
  final TextEditingController _boyiDanController = TextEditingController();
  final TextEditingController _boyiGachaController = TextEditingController();
  final TextEditingController _narxiDanController = TextEditingController();
  final TextEditingController _narxiGachaController = TextEditingController();
  final TextEditingController _marjaDanController = TextEditingController();
  final TextEditingController _marjaGachaController = TextEditingController();

  String? _nomerError, _eniError, _boyiError, _narxiError, _marjaError;
  CategoryModel? selectedCategory;

  void _validateInputs() {
    setState(() {
      _nomerError = _validatePair(_nomerDanController, _nomerGachaController);
      _eniError = _validatePair(_eniDanController, _eniGachaController);
      _boyiError = _validatePair(_boyiDanController, _boyiGachaController);
      _narxiError = _validatePair(_narxiDanController, _narxiGachaController);
      _marjaError = _validatePair(_marjaDanController, _marjaGachaController);
    });
  }

  String? _validatePair(TextEditingController danController,
      TextEditingController gachaController) {
    if ((danController.text.isNotEmpty && gachaController.text.isEmpty) ||
        (danController.text.isEmpty && gachaController.text.isNotEmpty)) {
      return 'Ikkalasini ham to\'ldirish kerak';
    }
    return null; // No error
  }

  String _getValues(TextEditingController danController,
      TextEditingController gachaController) {
    return '${danController.text} ${gachaController.text}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qidirish',
              style: bold.copyWith(),
            ),
            const SizedBox(height: 16),
            _buildInputRow('Nomer', _nomerDanController, _nomerGachaController,
                _nomerError),
            _buildInputRow(
                'Eni', _eniDanController, _eniGachaController, _eniError),
            _buildInputRow(
                "Bo'yi", _boyiDanController, _boyiGachaController, _boyiError),
            _buildInputRow('Narxi', _narxiDanController, _narxiGachaController,
                _narxiError),
            _buildInputRow('Marja', _marjaDanController, _marjaGachaController,
                _marjaError),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                TextButton(
                  child: Text(
                    'Bekor qilish',
                    style: pmedium.copyWith(color: context.textColor()),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  style: kButtonBackgroundStyle.copyWith(
                    backgroundColor:
                    WidgetStatePropertyAll(context.containerColor()),
                  ),
                  child: Text(
                    'Qidirish',
                    style: pmedium.copyWith(color: context.textColor()),
                  ),
                  onPressed: () {
                    _validateInputs();
                    if (_nomerError == null &&
                        _eniError == null &&
                        _boyiError == null &&
                        _narxiError == null &&
                        _marjaError == null) {
                      final nomerValue = _getValues(
                          _nomerDanController, _nomerGachaController);
                      final boyiValue =
                      _getValues(_boyiDanController, _boyiGachaController);
                      final eniValue =
                      _getValues(_eniDanController, _eniGachaController);
                      final narxiValue = _getValues(
                          _narxiDanController, _narxiGachaController);
                      final marjaValue = _getValues(
                          _marjaDanController, _marjaGachaController);
                      widget.onSearchTap.call(nomerValue, eniValue, boyiValue,
                          narxiValue, marjaValue, selectedCategory);
                      Navigator.of(context).pop();
                    }
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController danController,
      TextEditingController gachaController, String? errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: medium.copyWith(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: danController,
                  keyboardType: TextInputType.number,
                  style: medium.copyWith(fontSize: 16),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'dan',
                style: medium.copyWith(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: gachaController,
                  keyboardType: TextInputType.number,
                  style: medium.copyWith(fontSize: 16),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'gacha',
                style: medium.copyWith(fontSize: 16),
              ),
            ],
          ),
          if (errorText != null) // Show error text if there's any error
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText,
                style: medium.copyWith(fontSize: 12, color: AppColors.red),
              ),
            ),
        ],
      ),
    );
  }
}
