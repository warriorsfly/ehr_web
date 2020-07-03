import 'package:ehr_web/data/model/app_options.dart';
import 'package:ehr_web/themes/erb_theme_data.dart';
import 'package:ehr_web/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final bool isTestMode;
  final String initialRoute;

  const App({Key key, this.initialRoute, @required this.isTestMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AppOptions>(
      create: (_) => AppOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        appTextDirection: AppTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: isTestMode,
      ),
      builder: (context, _) => MaterialApp(
        title: 'Warriorsfly',
        // 是否显示右上角debug flag
        debugShowCheckedModeBanner: true,
        themeMode: context.watch<AppOptions>().themeMode,
        theme: EhrThemeData.lightThemeData
            .copyWith(platform: context.watch<AppOptions>().platform),

        darkTheme: EhrThemeData.darkThemeData
            .copyWith(platform: context.watch<AppOptions>().platform),

        initialRoute: initialRoute,
        locale: context.watch<AppOptions>().locale,
        // localeResolutionCallback: (locale, supportedLocales) {
        //   deviceLocale = locale;
        //   return locale;
        // },
        // onGenerateRoute: RouteConfiguration.onGenerateRoute,
      ),
    );
  }
}
