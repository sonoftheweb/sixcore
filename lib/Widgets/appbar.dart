import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Constants/colors.dart';

import '../Provider/app_provider.dart';

class AnimatedAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  const AnimatedAppbar({Key? key, this.title}) : super(key: key);

  @override
  State<AnimatedAppbar> createState() => _AnimatedAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _AnimatedAppbarState extends State<AnimatedAppbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));
    super.initState();
  }

  void showIcon() {
    _animationController.forward();
  }

  void hideIcon() {
    _animationController.reverse();
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) {
                return Consumer<AppProvider>(builder: (context, provider, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (provider.isDrawerOpen) {
                      showIcon();
                    } else {
                      hideIcon();
                    }
                  });
                  return IconButton(
                    onPressed: () {
                      if (_animation.value == 1) {
                        provider.isDrawerOpen = false;
                        hideIcon();
                      } else {
                        provider.isDrawerOpen = true;
                        showIcon();
                      }
                      Scaffold.of(context).openDrawer();
                    },
                    icon: AnimatedIcon(
                      color: AppColor.white,
                      icon: AnimatedIcons.menu_close,
                      progress: _animation,
                    ),
                  );
                });
              },
            ),
            Expanded(
              child: widget.title != null
                  ? Text(
                      widget.title!,
                      textAlign: TextAlign.center,
                    )
                  : Container(),
            ),
            const SizedBox(
              width: 35.0,
            ),
          ],
        ),
      ),
    );
  }
}
