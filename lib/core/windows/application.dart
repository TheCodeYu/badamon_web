import 'package:badamon_web/config/rx_config.dart';
import 'package:badamon_web/core/windows/windows.dart';
import 'package:flutter/material.dart';

///App应用层
///
///

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);
  static const rx_event_app = 'Application';

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  List<Offset> offset = [];

  ///保存显示的body
  List<AppManager> appBody = [];

  ///保存隐藏的body
  List<AppManager> cache = [];
  getAppWidget(int index, Widget widget) {
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
              this.offset[index] = Offset(offset.dx, offset.dy - 30);
            });
          },
          child: Container(color: Colors.transparent, child: widget),
        ));
  }

  Widget _buildChild(BuildContext context) {
    List<Widget> children = [];

    ///[todo] 每次增加要注意在最上面
    /// 每个App的信息
    for (var i = 0; i < appBody.length; i++) {
      children.add(getAppWidget(i, (appBody[i]..place = i).baseWindows));
    }
    return Stack(
      children: children,
    );
  }

  @override
  void initState() {
    ///监听增加App事件
    rx.subscribe(Application.rx_event_app, (data) {
      var temp;
      var t;
      switch (data['flag']) {
        case 'open':
          temp = data['data'] as BaseWindows;
          appBody.add(AppManager(temp, temp.appName()));
          break;
        case 'close':
          temp = data['data'];
          if (appBody.isNotEmpty) {
            appBody.forEach((element) {
              if (element.name == temp) t = element;
            });
            appBody.remove(t);
          }
          break;
        case 'min':
          temp = data['data'];
          if (appBody.isNotEmpty) {
            appBody.forEach((element) {
              if (element.name == temp) t = element;
            });
            appBody.remove(t);
          }
          cache.add(t);
          break;
        case 'max':
          temp = data['data'];
          if (cache.isNotEmpty) {
            cache.forEach((element) {
              if (element.name == temp) t = element;
            });

            cache.remove(t);
            appBody.add(t);
          }
          break;
        case 'focus':

          ///获得焦点
          temp = data['data'];
          if (appBody.isNotEmpty) {
            appBody.forEach((element) {
              if (element.name == temp) t = element;
            });

            appBody.remove(t);
            //appBody.add(t);
          }
          break;
      }
      setState(() {});
    }, name: this.runtimeType.toString());
    super.initState();
  }

  @override
  void dispose() {
    rx.unSubscribe(Application.rx_event_app, name: this.runtimeType.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChild(context),
    );
  }
}

///应用管理
class AppManager {
  int place = 0;
  final String name;
  final BaseWindows baseWindows;

  AppManager(this.baseWindows, this.name);
}
