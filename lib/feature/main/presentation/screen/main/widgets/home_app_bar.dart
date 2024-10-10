import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/utils/consants.dart';

import '../../../../../../core/theme/style_res.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onTapLeading;
  final VoidCallback onTapSearch;
  final VoidCallback onTapCancel;
  final VoidCallback onTapRefresh;
  final Function(String value) onChanged;

  const SearchAppBar({
    super.key,
    required this.onTapLeading,
    required this.onTapSearch,
    required this.onTapCancel,
    required this.onTapRefresh,
    required this.onChanged,
  });

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        onPressed: widget.onTapLeading,
        icon: const Icon(
          Icons.menu,
          color: AppColors.white,
        ),
      ),
      titleSpacing: 0,
      title: _isSearching
          ? Row(
              children: [
                IconButton(
                    icon: SvgPicture.asset(
                      AssetRes.icSearch,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: widget.onTapSearch),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: mediumWhite.copyWith(fontSize: 17),
                    // Custom text style
                    keyboardType: TextInputType.number,
                    onChanged: widget.onChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.paleBlue),
                    ),
                  ),
                ),
              ],
            )
          : const Text(''),
      actions: [
        IconButton(
          icon: _isSearching
              ? const Icon(Icons.close, color: AppColors.white)
              : SvgPicture.asset(
                  AssetRes.icSearch,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
          onPressed: () {
            widget.onTapCancel.call();
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            });
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            AssetRes.icSynchronization,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            widget.onTapRefresh.call();
          },
        ),
      ],
    );
  }
}
