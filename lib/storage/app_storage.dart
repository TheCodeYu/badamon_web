import 'dart:convert';
import 'package:badamon_web/blocs/global/global_bloc.dart';
import 'package:badamon_web/config/rx_config.dart';
import 'package:badamon_web/constants/cons.dart';
import 'package:badamon_web/constants/sp.dart';
import 'package:badamon_web/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_ui.dart';

///应用全局存储读写接口
class AppStorage {
  late SharedPreferences _sp;

  get sp => _sp;

  // 初始化 App 固化的配置数据
  Future<GlobalState> initApp() async {
    rx.push(Rx.rx_event_splash[0], data: 0.0);
    await LogUtil.init();
    _sp = await SharedPreferences.getInstance();

    rx.push(Rx.rx_event_splash[0], data: 50.0);
    var themeIndex = _sp.getInt(SP.themeColorIndex) ?? 4;
    var fontIndex = _sp.getInt(SP.fontFamily) ?? 1;

    var localeIndex = _sp.getInt(SP.locale) ?? 0;

    rx.push(Rx.rx_event_splash[0], data: 100.0);
    return GlobalState(
      themeColor: Cons.themeColorSupport.keys.toList()[themeIndex],
      fontFamily: Cons.fontFamilySupport[fontIndex],
      locale: AppLocalizations.supportedLocales[localeIndex],
    );
  }

  GlobalState intoHome() {
    var showBg = _sp.getBool(SP.showBackground) ?? true;
    var codeIndex = _sp.getInt(SP.codeStyleIndex) ?? 0;
    var itemStyleIndex = _sp.getInt(SP.itemStyleIndex) ?? 0;
    var appui = _sp.getString(SP.appUI);
    AppUI appUI = AppUI();
    if (appui != null) {
      appUI = AppUI.fromJson(jsonDecode(appui));
    }

    return GlobalState().copyWith(
        showBackGround: showBg,
        itemStyleIndex: itemStyleIndex,
        codeStyleIndex: codeIndex,
        appUI: appUI);
  }

  ///退出时操作保存数据
  exitApp(context) {
    var appUI = AppUI.copy(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    _sp..setString(SP.appUI, jsonEncode(appUI.toJson())); //固化数据
  }
}
