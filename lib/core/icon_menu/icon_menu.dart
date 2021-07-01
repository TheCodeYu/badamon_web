import 'package:badamon_web/blocs/global/global_bloc.dart';
import 'package:badamon_web/components/drag_view/drag_view.dart';
import 'package:badamon_web/config/rx_config.dart';
import 'package:badamon_web/core/all_based.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///桌面按钮
///
///

class IconMenuBean extends DragBean {
  final Color color;
  final String name;
  final int flag; //图标类型
  ///应用唯一标志符，可以用router定义
  final String disPlayName;
  //final PopupMenuButton right;
  IconMenuBean(this.color, this.name, this.disPlayName, this.flag);
}

class IconMenu extends StatefulWidget {
  const IconMenu(this.iconMenuBean, {Key? key}) : super(key: key);
  static const rx_event_IconMenu = <String>['focus'];
  final IconMenuBean iconMenuBean;
  @override
  _IconMenuState createState() => _IconMenuState();
}

class _IconMenuState extends State<IconMenu> with AllBased {
  bool hasFocus = false;
  Offset globalPosition = Offset.zero;
  @override
  void initState() {
    ///Build结束，你的回调就会执行

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      rx.subscribe(IconMenu.rx_event_IconMenu[0], (data) {
        if (data['name'] != widget.iconMenuBean.name) {
          hasFocus = data['focus'];
          setState(() {});
        }
      }, name: widget.iconMenuBean.name + widget.iconMenuBean.flag.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    rx.unSubscribe(IconMenu.rx_event_IconMenu[0],
        name: widget.iconMenuBean.name + widget.iconMenuBean.flag.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        rx.push(IconMenu.rx_event_IconMenu[0],
            data: {'focus': false, 'name': widget.iconMenuBean.name});
        setState(() {
          hasFocus = true;
        });
      },
      onDoubleTap: () {
        rx.push(IconMenu.rx_event_IconMenu[0],
            data: {'focus': false, 'name': widget.iconMenuBean.name});
      },
      onSecondaryTapDown: (details) {
        globalPosition = details.globalPosition;
      },
      onSecondaryTap: () {
        rx.push(IconMenu.rx_event_IconMenu[0],
            data: {'focus': false, 'name': widget.iconMenuBean.name});
        setState(() {
          hasFocus = true;
        });
        showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                globalPosition.dx,
                globalPosition.dy,
                globalPosition.dx + 50,
                globalPosition.dy + 100),
            items: <PopupMenuEntry>[
              PopupMenuItem(
                height: kMinInteractiveDimension,
                child: Text('111111'),
              ),
            ]);
      },
      child: Tooltip(
          message: widget.iconMenuBean.disPlayName,
          child: Container(
            decoration: BoxDecoration(
                color: hasFocus
                    ? (Colors.blue.withOpacity(0.2))
                    : Colors.transparent),
            child: (widget.iconMenuBean.flag) == 1
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/os/images/${widget.iconMenuBean.disPlayName}.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        widget.iconMenuBean.disPlayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: BlocProvider.of<GlobalBloc>(context)
                                .state
                                .fontFamily,
                            fontSize: sp(6)),
                      ),
                    ],
                  )
                : Container(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/os/images/${widget.iconMenuBean.disPlayName}.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    width: 20,
                    height: 20,
                  ),
          )),
    );
  }
}
