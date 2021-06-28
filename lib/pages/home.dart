import 'package:badamon_web/components/tools/title_bar.dart';
import 'package:badamon_web/components/tools/tools_bar.dart';
import 'package:badamon_web/constants/cons.dart';
import 'package:badamon_web/core/all_based.dart';
import 'package:badamon_web/core/windows/application.dart';
import 'package:badamon_web/pages/background.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static final defaultRoute = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AllBased {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
            height: Cons.titleBarHeight,
            color: Colors.indigo.withOpacity(0.6),
            child: TitleBar()),
        Expanded(
            child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/os/images/bg.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Background(),
            Application(),
            Visibility(
              visible: true,

              ///直接不渲染
              child: Column(
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  ToolsBar(),
                  SizedBox(
                    height: dh(5),
                  )
                ],
              ),
            )
          ],
        )),
      ]),

      // builder: (BuildContext context, Widget? child) {
      //   return FlutterSmartDialog(child: child);
      // },
    );
  }
}
