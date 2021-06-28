import 'package:badamon_web/components/drag_view/drag_view.dart';
import 'package:badamon_web/core/all_based.dart';
import 'package:badamon_web/core/icon_menu/icon_menu.dart';
import 'package:badamon_web/utils/log_utils.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  const Background({Key? key}) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with WidgetsBindingObserver, AllBased {
  List<IconMenuBean> imageList = [
    IconMenuBean(Colors.brown, '1', '1', 1),
    IconMenuBean(Colors.pink, '2', '2', 1),
    IconMenuBean(Colors.grey, '3', '3', 1),
    IconMenuBean(Colors.orange, '4', '4', 1),
    IconMenuBean(Colors.green, '5', '5', 1),
    IconMenuBean(Colors.blue, '6', '6', 1),
    IconMenuBean(Colors.red, '7', '7', 1),
    IconMenuBean(Colors.yellow, '8', '8', 1),
    IconMenuBean(Colors.black, '9', '9', 1)
  ];
  int moveAction = MotionEvent.actionUp;
  bool _canDelete = false;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dw(MediaQuery.of(context).size.width),

      ///[todo] 配置
      height: MediaQuery.of(context).size.height - dh(50),
      child: DragView(
        data: imageList,
        space: dw(5),
        itemWidth: dw(35),
        margin: EdgeInsets.all(dw(20)),
        padding: EdgeInsets.all(0),
        itemBuilder: (BuildContext context, int index) {
          IconMenuBean bean = imageList[index];
          // It is recommended to use a thumbnail picture
          //print(index);
          return IconMenu(
            bean,
          );
        },
        initBuilder: (BuildContext context) {
          return SizedBox();
        },
        onDragListener: (MotionEvent event, double itemWidth) {
          switch (event.action) {
            case MotionEvent.actionDown:
              moveAction = event.action;
              setState(() {});
              break;
            case MotionEvent.actionMove:
              double x = event.globalX + itemWidth;
              double y = event.globalY + itemWidth;
              double maxX = MediaQuery.of(context).size.width - 1 * 100;
              double maxY = MediaQuery.of(context).size.height - 1 * 100;

              ///print('maxX: $maxX, maxY: $maxY, x: $x, y: $y');
              if (_canDelete && (x < maxX || y < maxY)) {
                setState(() {
                  _canDelete = false;
                });
              } else if (!_canDelete && x > maxX && y > maxY) {
                setState(() {
                  _canDelete = true;
                });
              }
              break;

            case MotionEvent.actionUp:
              moveAction = event.action;
              if (_canDelete) {
                setState(() {
                  _canDelete = false;
                });
                return true;
              } else {
                setState(() {});
              }
              break;
          }
          return false;
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
    LogUtil.info(this.runtimeType.toString(), 'AppLifecycleState:$state');
  }
}
