import 'package:flutter/material.dart';
import 'package:jd_dropdowm_menu_widget/jd_drop_down_menu.dart';
import 'package:jd_dropdowm_menu_widget/jd_dropdowm_menu_widget.dart';
import 'package:jd_dropdowm_menu_widget/jd_pop_widget.dart';

import 'demo/city_widget.dart';
import 'demo/menu_list_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title1 = '城市';
  String title2 = '品牌';
  GlobalKey _key1 = GlobalKey();

  JDDropdownMenuController controller = JDDropdownMenuController();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          TextButton(
              key: _key1,
              onPressed: () {
                RenderBox renderBox = _key1.currentContext.findRenderObject();
                Rect position =
                    renderBox.localToGlobal(Offset.zero) & renderBox.size;
                showDropdownMenu(
                  position: position,
                  context: context,
                  pageBuilder: (c1) => Container(
                    color: Colors.orange,
                  ),
                );
              },
              child: Text(
                '下拉菜单',
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: JDDropdownMenuWidget(
              controller: controller,
              itemStyle: JDDropdownMenuWidgetStyle.style2,
              click: (int index) {
                print('$index');
              },
              items: [
                JDDropdownMenuItem(
                  maxHeight: 300,
                  title: Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(title1),
                  ),
                  menu: CityWidget(
                    click: (String selectedValue) {
                      setState(() {
                        title1 = selectedValue;
                        controller.hide();
                      });
                      print('选择的城市为:$selectedValue');
                    },
                  ),
                ),
                JDDropdownMenuItem(
                  maxHeight: 300,
                  title: Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(title2),
                  ),
                  menu: MenuListWidget(
                    selectedValue: title2,
                    click: (String value) {
                      setState(() {
                        title2 = value;
                        controller.hide();
                      });
                    },
                  ),
                ),
                JDDropdownMenuItem(
                  title: Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text('菜单3'),
                  ),
                  menu: Container(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Builder(
              builder: (c) {
                return TextButton(
                    onPressed: () {
                      RenderBox renderBox = c.findRenderObject();
                      Rect position =
                          renderBox.localToGlobal(Offset.zero) & renderBox.size;
                      showDropdownMenu(
                        position: position,
                        context: c,
                        pageBuilder: (c1) => Container(
                          color: Color(0xffff0000),
                        ),
                      );
                    },
                    child: Text('Menu1'));
              },
            ),
          ),
          Container(
            child: Builder(
              builder: (c) {
                return TextButton(
                    onPressed: () {
                      showPop(
                        backgroundColor: Colors.red,
                        barrierColor: const Color(0x00000000),
                        context: c,
                        items: [
                          Text(
                            '个人信息',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '退出',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      );
                    },
                    child: Text('Menu2'));
              },
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
