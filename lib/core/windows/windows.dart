import 'package:badamon_web/config/rx_config.dart';
import 'package:badamon_web/constants/cons.dart';
import 'package:flutter/material.dart';

import 'application.dart';

///桌面窗口基类
///
///

class TestApp extends BaseWindows {
  const TestApp({
    Key? key,
    required this.child,
    required this.windowsFlag,
    this.context,
    required this.name,
    required this.menu,
  }) : super(key: key);

  final Widget child;

  final String name;

  final int windowsFlag;

  final BuildContext? context;

  final String menu;
  @override
  String appName() => 'Test:' + name;

  @override
  Widget getChild() => child;

  @override
  BuildContext? getHomeContext() => context;

  @override
  int getWindowFlag() => windowsFlag;

  @override
  String appMenu() => menu;
}

class Aaa extends StatefulWidget {
  const Aaa(this.i, {Key? key}) : super(key: key);

  final int i;
  @override
  _AaaState createState() => _AaaState();
}

class _AaaState extends State<Aaa> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('qwewqeqweqwe:${widget.i}'),
      ),
    );
  }
}

abstract class BaseWindows extends StatefulWidget {
  const BaseWindows({Key? key}) : super(key: key);

  ///应用整体
  Widget getChild();

  ///应用名
  String appName();

  ///返回按钮的上下文
  BuildContext? getHomeContext();

  ///窗体模式
  int getWindowFlag(); //App打开模式

  ///App图标
  String appMenu();

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

  getTitleBar() {
    return Container(
      height: Cons.titleBarHeight,
      child: Row(
        children: [
          Expanded(
            child: Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Image.asset(widget.appMenu()),
                    Text(widget.appName())
                  ],
                )),
          ),
          IconButton(
              onPressed: () {
                rx.push(Application.rx_event_app,
                    data: {'flag': 'min', 'data': widget.appName()});
              },
              icon: Icon(Icons.minimize)),
          IconButton(
              onPressed: () {
                rx.push(Application.rx_event_app,
                    data: {'flag': 'max', 'data': widget.appName()});
              },
              icon: Icon(Icons.content_copy_rounded)),
          IconButton(
            onPressed: () {
              rx.push(Application.rx_event_app,
                  data: {'flag': 'close', 'data': widget.appName()});
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
    );
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
                rx.push(Application.rx_event_app,
                    data: {'flag': 'focus', 'data': widget.appName()});
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
                  getTitleBar()
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
