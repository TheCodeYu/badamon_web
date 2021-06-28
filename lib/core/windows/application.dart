import 'package:badamon_web/config/rx_config.dart';
import 'package:badamon_web/core/windows/windows.dart';
import 'package:flutter/material.dart';

///App应用层
///
///

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);
  static const rx_event_app = <String>['openApp'];

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  int count = 0;
  List<Offset> offset = [];
  getAppWidget(int index) {
    offset.add(Offset.zero);
    return Positioned(
        left: offset[index].dx,
        top: offset[index].dy,
        height: 400,
        width: 400,
        child: Draggable(
          feedback: Container(
            height: 400,
            width: 400,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.white30)),
          ),
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            setState(() {
              /// [todo] 这个31咋算
              this.offset[index] = Offset(offset.dx, offset.dy - 31);
            });
          },
          child: Container(
            color: Colors.transparent,
            child: TestApp(
              child: Aaa(),
              name: 'TestApp:$index',
              windowsFlag: 0,
            ),
          ),
        ));
  }

  Widget _buildChild(BuildContext context) {
    List<Widget> children = [];

    ///[todo] 每次增加要注意在最上面
    /// 每个App的信息
    for (var i = 0; i < count; i++) {
      children.add(getAppWidget(i));
    }
    return Stack(
      children: children,
    );
  }

  @override
  void initState() {
    ///监听增加App事件
    rx.subscribe(Application.rx_event_app[0], (data) {
      count++;
      setState(() {});
    }, name: this.runtimeType.toString());
    super.initState();
  }

  @override
  void dispose() {
    rx.unSubscribe(Application.rx_event_app[0],
        name: this.runtimeType.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChild(context),
    );
  }
}
