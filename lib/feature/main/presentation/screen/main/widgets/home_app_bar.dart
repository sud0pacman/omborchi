import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/color_scheme.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/utils/consants.dart';

import '../../../../../../core/theme/style_res.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onTapLeading;
  final VoidCallback onTapSearch;
  final VoidCallback onTapCancel;
  final VoidCallback onTapRefresh;
  final bool isGridView;
  final Function(String value) onChanged;
  final Function(bool) onViewToggle; // Yangi callback

  const SearchAppBar({
    super.key,
    required this.onTapLeading,
    this.isGridView = true,
    required this.onTapSearch,
    required this.onTapCancel,
    required this.onTapRefresh,
    required this.onChanged,
    required this.onViewToggle,
  });

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  bool isGridView = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: widget.onTapLeading,
        icon: const Icon(Icons.menu, color: AppColors.white),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: context.colorScheme().appBarDivColor,
          height: 1,
        ),
      ),
      title: _isSearching ? _buildSearchField() : const Text(''),
      actions: [
        IconButton(
          icon: _isSearching
              ? const Icon(Icons.close, color: AppColors.white)
              : SvgPicture.asset(
                  AssetRes.icSearch,
                  width: 24,
                  height: 24,
                  colorFilter:
                      const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                ),
          onPressed: () {
            widget.onTapCancel.call();
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchController.clear();
            });
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            AssetRes.icSynchronization,
            width: 24,
            height: 24,
            colorFilter:
                const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          ),
          onPressed: widget.onTapRefresh,
        ),
        IconButton(
          icon: Icon(
            isGridView
                ? CupertinoIcons.list_bullet
                : CupertinoIcons.square_grid_2x2,
            color: AppColors.white,
          ),
          onPressed: () {
            setState(() {
              isGridView = !isGridView;
            });
            widget.onViewToggle.call(isGridView);
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            AssetRes.icSearch,
            width: 24,
            height: 24,
            colorFilter:
                const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          ),
          onPressed: widget.onTapSearch,
        ),
        Expanded(
          child: TextField(
            controller: _searchController,
            style:
                mediumWhite.copyWith(fontSize: 17, color: context.textColor()),
            keyboardType: TextInputType.number,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(
              hintText: 'Qidirish...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: AppColors.paleBlue),
            ),
          ),
        ),
      ],
    );
  }
}
