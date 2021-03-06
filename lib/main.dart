import 'dart:ui';

import 'package:badamon_web/blocs/bloc_wrapper.dart';
import 'package:badamon_web/blocs/global/global_bloc.dart';
import 'package:badamon_web/config/i10n.dart';
import 'package:badamon_web/config/router_config.dart';
import 'package:badamon_web/pages/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_strategy/url_strategy.dart';

main() {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocWrapper(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(builder: (ctx, state) {
      return ScreenUtilInit(
          designSize: Size(600, 450),
          builder: () => MaterialApp(
                // shortcuts: <LogicalKeySet, Intent>{
                //   ...WidgetsApp.defaultShortcuts,
                //   LogicalKeySet(
                //       LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
                //   const SearchIntent(),
                // },
                // actions: <Type, Action<Intent>>{
                //   ...WidgetsApp.defaultActions,
                //   SearchIntent: ActionUnit.searchAction,
                // },
                debugShowCheckedModeBanner: false,
                onGenerateTitle: (context) => AppLocalizations.of(context)!.app,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: [
                  LocaleNamesLocalizationsDelegate(),
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  const FallbackCupertinoLocalisationsDelegate(),
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: state.locale,
                localeResolutionCallback:

                    /// [supportedLocales] : supportedLocales
                    ///iOS???????????????????????? [en_US, zh_CN]  zh_Hans_CN languageCode-scriptCode-countryCode
                    (Locale? _locale, Iterable<Locale>? supportedLocales) {
                  if (_locale != null) {
                    return _locale;
                  }

                  Locale locale = Locale.fromSubtags(
                      languageCode: 'zh',
                      scriptCode: 'Hans',
                      countryCode: 'CN'); //???APP??????????????????????????????????????????????????????
                  /// [todo]???????????????????????????????????????????????????,??????????????????????????????????????????????????????,ios????????????????????????
                  supportedLocales?.forEach((l) {
                    if ((l.countryCode == _locale?.countryCode) &&
                        (l.languageCode == _locale?.languageCode)) {
                      locale = Locale.fromSubtags(
                          languageCode: l.languageCode,
                          scriptCode: l.scriptCode,
                          countryCode: l.countryCode);
                    }
                  });
                  return locale;
                },
                onGenerateRoute: RouterConfig.onGenerateRoute,
                theme: ThemeData(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  primarySwatch: state.themeColor,
                  fontFamily: state.fontFamily,
                ),
                home: Splash(),
              )
          // builder: (BuildContext context, Widget? child) {
          //   return FlutterSmartDialog(child: child);
          // },
          );
    });
  }
}
