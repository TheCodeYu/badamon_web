import 'dart:ui';

import 'package:badamon_web/core/all_based.dart';
import 'package:badamon_web/core/icon_menu/icon_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

class ToolsBar extends StatefulWidget {
  const ToolsBar({Key? key}) : super(key: key);

  @override
  _ToolsBarState createState() => _ToolsBarState();
}

class _ToolsBarState extends State<ToolsBar> with AllBased {
  List<IconMenuBean> imageList = [
    IconMenuBean(Colors.brown, '1', '1', 2),
    IconMenuBean(Colors.pink, '2', '2', 2),
    IconMenuBean(Colors.grey, '3', '3', 2),
    IconMenuBean(Colors.orange, '4', '4', 2),
    IconMenuBean(Colors.green, '5', '5', 2),
    IconMenuBean(Colors.blue, '6', '6', 2),
    IconMenuBean(Colors.red, '7', '7', 2),
    IconMenuBean(Colors.yellow, '8', '8', 2),
    IconMenuBean(Colors.black, '9', '9', 2)
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          print('左击(ToolsBar )');
        },
        onDoubleTap: () {
          print('双击(ToolsBar )');
        },
        onSecondaryTap: () {
          print('右击(ToolsBar )');
        },
        child: Container(
          margin: EdgeInsets.only(left: dw(50), right: dw(50)),
          height: dh(35),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  //盒子装饰器，进行装饰，设置颜色为灰色
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: dw(50), right: dw(50)),
        height: dh(35),
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  child: Swiper(
                      index: 0,
                      itemCount: imageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return IconMenu(imageList[index]);
                      },
                      autoplay: true,
                      scrollDirection: Axis.horizontal,
                      containerWidth: dw(25),
                      itemWidth: dw(25),
                      viewportFraction: 1 / 8,
                      scale: 0.1,
                      fade: 0.1),
                )),
            Container(
              // height: dw(35),
              width: 1,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
            ),
            Container(
              width: dw(100),
              child: Swiper(
                  index: 0,
                  itemCount: imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return IconMenu(imageList[index]);
                  },
                  autoplay: true,
                  scrollDirection: Axis.horizontal,
                  containerWidth: dw(25),
                  itemWidth: dw(25),
                  viewportFraction: 1 / 3,
                  scale: 0.1,
                  fade: 0.1),
            ),
            Container(
              // height: dw(35),
              width: 1,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: dw(5), right: dw(5)),
              child: IconMenu(IconMenuBean(
                  Colors.transparent, 'TrashIcon', 'TrashIcon', 2)),
            ),
          ],
        ),
      )
    ]);
  }
}
