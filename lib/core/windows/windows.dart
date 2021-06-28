import 'package:badamon_web/components/tools/title_bar.dart';
import 'package:badamon_web/constants/cons.dart';
import 'package:flutter/material.dart';

///桌面窗口基类
///
///

class TestApp extends BaseWindows {
  const TestApp(
      {Key? key,
      required this.child,
      required this.windowsFlag,
      this.context,
      required this.name})
      : super(key: key);

  final Widget child;

  final String name;

  final int windowsFlag;

  final BuildContext? context;

  @override
  String appName() => 'Test:' + name;

  @override
  Widget getChild() => child;

  @override
  BuildContext? getHomeContext() => context;

  @override
  int getWindowFlag() => windowsFlag;
}

class Aaa extends StatefulWidget {
  const Aaa({Key? key}) : super(key: key);

  @override
  _AaaState createState() => _AaaState();
}

class _AaaState extends State<Aaa> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('qwewqeqweqwe'),
      ),
    );
  }
}

abstract class BaseWindows extends StatefulWidget {
  const BaseWindows({Key? key}) : super(key: key);

  Widget getChild();

  String appName();

  BuildContext? getHomeContext();

  int getWindowFlag(); //App打开模式
  @override
  _BaseWindowsState createState() => _BaseWindowsState();
}

class _BaseWindowsState extends State<BaseWindows> {
  late final Widget child;
  @override
  void initState() {
    child = widget.getChild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.getWindowFlag()) {
      case 1:
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.appName()),
          ),
          body: child,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartFloat,
          floatingActionButton: widget.getHomeContext() != null
              ? IconButton(
                  onPressed: () => Navigator.of(widget.getHomeContext()!).pop(),
                  icon: Icon(Icons.arrow_back_ios),
                )
              : null,
        );

      default:
        return Stack(children: [
          Container(
            color: Colors.indigo.withOpacity(0.6),
            child: GestureDetector(
              onDoubleTap: () {
                print('双击:${widget.appName()}');
              },
              onTap: () {
                print('单击:${widget.appName()}');
              },
              onSecondaryTap: () {
                print('右击:${widget.appName()}');
              },
              child: Stack(
                children: [
                  Container(
                    height: Cons.titleBarHeight,
                    color: Colors.red,
                  ),
                  TitleBar()
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: Cons.titleBarHeight),
            child: child,
          )
        ]);
    }
  }
}
