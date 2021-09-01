import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// @author jd

typedef JDDropdownMenuClick = void Function(int index);
typedef JDDropdownMenuDismiss = void Function();

//用于多级下拉菜单

enum JDDropdownMenuWidgetStyle {
  style1, //自适应
  style2, //等分
}

class JDDropdownMenuItem {
  final Widget title; //菜单点击区域
  final Widget menu; //菜单下拉内容区域
  final double maxHeight; //内容区域高度

  JDDropdownMenuItem({
    required this.title,
    required this.menu,
    this.maxHeight = 100,
  });
}

//Controller
class JDDropdownMenuController extends ChangeNotifier {
  bool isShow = false;
  int menuIndex = 0;

  void show(int index) {
    isShow = true;
    menuIndex = index;
    notifyListeners();
  }

  void hide() {
    isShow = false;
    notifyListeners();
  }
}

class JDDropdownMenuWidget extends StatefulWidget {
  final List<JDDropdownMenuItem> items;
  final JDDropdownMenuClick? click;
  final JDDropdownMenuDismiss? dismiss;
  final JDDropdownMenuWidgetStyle? itemStyle;
  final JDDropdownMenuController? controller;
  final double height;
  JDDropdownMenuWidget({
    required this.items,
    this.height = 40,
    this.click,
    this.dismiss,
    this.itemStyle = JDDropdownMenuWidgetStyle.style1,
    this.controller,
  });

  @override
  _JDDropdownMenuWidgetState createState() => _JDDropdownMenuWidgetState();
}

class _JDDropdownMenuWidgetState extends State<JDDropdownMenuWidget>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  late Animation _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(
          milliseconds: 200,
        ),
        vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.dismissed) {
        _entry!.remove();
        _entry = null;
        if (widget.dismiss != null) {
          widget.dismiss!();
        }
      }
    });
    widget.controller?.addListener(() {
      if (widget.controller!.isShow) {
        JDDropdownMenuItem item = widget.items[widget.controller!.menuIndex];
        showMenu(context, item);
      } else {
        dismiss();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        children: widget.items
            .map(
              (e) => menuItemWidget(e),
            )
            .toList(),
      ),
    );
  }

  Widget menuItemWidget(JDDropdownMenuItem item) {
    Widget menu = Builder(
      builder: (BuildContext c) => GestureDetector(
        onTap: () {
          showMenu(c, item);
        },
        child: item.title,
      ),
    );
    if (widget.itemStyle == JDDropdownMenuWidgetStyle.style2) {
      menu = Expanded(
        child: menu,
      );
    }
    return menu;
  }

  void showMenu(BuildContext context, JDDropdownMenuItem item) {
    widget.controller?.isShow = true;
    if (widget.click != null) {
      widget.click!(widget.items.indexOf(item));
    }
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Rect position = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    if (_entry != null) {
      _entry!.remove();
      _entry = null;
    }

    _entry = OverlayEntry(
      builder: (BuildContext context) => Positioned.fill(
        top: position.bottom,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              SizeTransition(
                sizeFactor: _animation as Animation<double>,
                child: Container(
                  child: item.menu,
                  height: item.maxHeight,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    dismiss();
                  },
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Container(
                      color: const Color(0x80000000),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_entry!);
    _animationController.forward();
  }

  void dismiss() {
    widget.controller?.isShow = false;
    if (_entry != null) {
      _animationController.reverse();
    }
  }
}
