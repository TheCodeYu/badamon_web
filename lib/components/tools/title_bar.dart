import 'dart:async';

import 'package:badamon_web/config/rx_config.dart';
import 'package:badamon_web/constants/cons.dart';
import 'package:badamon_web/core/windows/application.dart';
import 'package:badamon_web/core/windows/windows.dart';

import 'package:flutter/material.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    Timer.periodic(const Duration(microseconds: 1000 * 60), (Timer t) {
      if (!mounted) {
        return;
      }

      setState(() {
        now = DateTime.now();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Cons.titleBarHeight,
      child: Row(
        children: [
          Expanded(
            child: Container(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/os/tools/apple.png')),
          ),
          IconButton(
              tooltip: 'bluetooth',
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              iconSize: 6,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => TestApp(
                      child: Aaa(),
                      context: context,
                      name: 'App',
                      windowsFlag: 1,
                    ),
                  ),
                );
              },
              icon: Image.asset('assets/os/tools/bluetooth.png')),
          IconButton(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              iconSize: 6,
              onPressed: () {
                rx.push(Application.rx_event_app[0], data: {});
              },
              icon: Image.asset('assets/os/tools/battery.png')),
          IconButton(
              iconSize: 6,
              onPressed: () {},
              icon: Image.asset('assets/os/tools/wifi.png')),
          IconButton(
              iconSize: 6,
              onPressed: () {},
              icon: Image.asset('assets/os/tools/search.png')),
          IconButton(
              iconSize: 6,
              onPressed: () {},
              icon: Image.asset('assets/os/tools/control.png')),
          Text(
            "${now.year}-${now.month}-${now.day} ${now.weekday} ${(now.hour)}:${(now.minute)}",
          )
        ],
      ),
    );
  }
}
