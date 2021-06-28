import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllBased {
  dw(double w) => ScreenUtil().setWidth(w);

  dh(double h) => ScreenUtil().setHeight(h);

  sp(double h) => ScreenUtil().setSp(h);

  locale(context) => AppLocalizations.of(context)!;
}
