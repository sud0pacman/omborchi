import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:path/path.dart';
import 'package:popover/popover.dart';

class PopUpMenu extends StatelessWidget {
  final List<String> actions;
  final List<String> iconPaths;
  final Function(int) onPressed;

  const PopUpMenu(
      {super.key,
      required this.actions,
      required this.iconPaths,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < actions.length; i++)
          item(() => onPressed(i), iconPaths[i], actions[i], context)
      ],
    );
  }

  Widget item(
      VoidCallback onPressed, String path, String title, BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: kButtonTransparentStyle.copyWith(
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
          ),
        ),
        child: SizedBox(
          height: 32,
          child: Row(children: [
            SvgPicture.asset(
              path,
              width: 22,
              height: 22,
              colorFilter:
                  ColorFilter.mode(context.textColor(), BlendMode.srcIn),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: semiBold.copyWith(fontSize: 16, color: context.textColor()),
              overflow: TextOverflow.ellipsis,
            )
          ]),
        ));
  }
}

class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GestureDetector(
        child: const Center(child: Text('Click Me')),
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => const ListItems(),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.white,
            width: 200,
            height: 400,
            arrowHeight: 15,
            arrowWidth: 30,
          );
        },
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {
              // Navigator.of(context)
              //   ..pop()
              //   ..push(
              //     MaterialPageRoute<SecondRoute>(
              //       builder: (context) => SecondRoute(),
              //     ),
              //   );
            },
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[400],
            child: const Center(child: Text('Entry D')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[500],
            child: const Center(child: Text('Entry E')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[600],
            child: const Center(child: Text('Entry F')),
          ),
        ],
      ),
    );
  }
}
