library jd_drop_down_menu;

import 'package:flutter/material.dart';

typedef PageBuilder = Widget Function(BuildContext context);

//用于导航下显示单个下拉菜单

void showDropdownMenu({
  required BuildContext context,
  required PageBuilder pageBuilder,
  required Rect position,
  double menuHeight = 100,
  bool barrierDismissible = true,
  Duration transitionDuration = const Duration(milliseconds: 300),
}) {
  assert(position != null);
  Navigator.push(
      context,
      _JDDropDownMenuRoute(
        pageBuilder: pageBuilder,
        position: position,
        menuHeight: menuHeight,
        barrierDismissible: barrierDismissible,
        transitionDuration: transitionDuration,
      ));
}

class _JDDropDownMenuRoute extends PopupRoute {
  final Rect? position;
  final double? menuHeight;

  _JDDropDownMenuRoute({
    required PageBuilder pageBuilder,
    this.position,
    this.menuHeight,
    Color barrierColor = const Color(0x80000000),
    bool barrierDismissible = true,
    Duration? transitionDuration,
  })  : _pageBuilder = pageBuilder,
        _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible,
        _transitionDuration = transitionDuration;

  final PageBuilder _pageBuilder;
  final Color _barrierColor;
  final bool _barrierDismissible;
  final Duration? _transitionDuration;
  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => _transitionDuration!;

  // @override
  // bool get opaque => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget child = _pageBuilder(context);

    return CustomSingleChildLayout(
      delegate: _JDDropDownMenuRouteLayout(
          position: position, menuHeight: menuHeight),
      child: Container(
        color: _barrierColor,
        child: Column(
          children: [
            SizeTransition(
              sizeFactor:
                  Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: Container(
                child: child,
                height: menuHeight,
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_barrierDismissible) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            )
          ],
        ),
      ),
    );

    // return Container(
    //   color: Colors.transparent,
    //   child: Column(
    //     children: [
    //       Container(
    //         margin: EdgeInsets.only(top: position.bottom),
    //         child: SizeTransition(
    //           sizeFactor:
    //               Tween<double>(begin: 0.0, end: 1.0).animate(animation),
    //           child: Container(
    //             child: child,
    //             height: menuHeight,
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         child: GestureDetector(
    //           onTap: () {
    //             if (_barrierDismissible) {
    //               Navigator.pop(context);
    //             }
    //           },
    //           child: Container(
    //             color: _barrierColor,
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}

class _JDDropDownMenuRouteLayout extends SingleChildLayoutDelegate {
  final Rect? position;
  final double? menuHeight;
  _JDDropDownMenuRouteLayout({this.position, this.menuHeight});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(
        Size(constraints.maxWidth, constraints.maxHeight));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0, position!.bottom);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}
