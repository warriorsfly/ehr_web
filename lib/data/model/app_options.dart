import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:ehr_web/constants.dart';
import 'package:provider/provider.dart';

enum AppTextDirection {
  localeBased,
  ltr,
  rtl,
}

const List<String> rtlLanguages = [
  'ar', // Arabic
  'fa', // Farsi
  'he', // Hebrew
  'ps', // Pashto
  'ur', // Urdu
];

// app运行环境所在地
const systemLocation = Locale('system');

Locale _deviceLocale;

Locale get deviceLocale => _deviceLocale;
set deviceLocal(Locale value) {
  _deviceLocale ??= value;
}

class AppOptions {
  const AppOptions(
      {@required this.themeMode,
      @required double textScaleFactor,
      @required this.appTextDirection,
      @required Locale locale,
      @required this.timeDilation,
      @required this.platform,
      @required this.isTestMode})
      : _textScaleFactor = textScaleFactor,
        _locale = locale;

  /// 颜色深浅模式
  final ThemeMode themeMode;

  final double _textScaleFactor;

  /// 字体方向
  final AppTextDirection appTextDirection;

  /// 地址
  final Locale _locale;

  final double timeDilation;

  final TargetPlatform platform;

  /// 测试模式
  final bool isTestMode;

  /// 字体大小
  /// [context] 上下文
  /// [useDefault] 是否使用固定值
  double textScaleFactor(BuildContext context, {bool useDefault = false}) {
    if (_textScaleFactor == systemTextScaleFactorOption) {
      return useDefault
          ? systemTextScaleFactorOption
          : MediaQuery.of(context).textScaleFactor;
    } else {
      return _textScaleFactor;
    }
  }

  /// 全球化,本地化参数
  Locale get locale => _locale ??
          deviceLocale ??
          (!kIsWeb &&
              (Platform.isMacOS || Platform.isWindows || Platform.isLinux))
      ? const Locale('zh', 'CN')
      : null;

  /// 文字方向
  TextDirection resolvedTextDirection() {
    switch (appTextDirection) {
      case AppTextDirection.localeBased:
        final language = locale?.languageCode?.toLowerCase();
        if (language == null) return null;
        return rtlLanguages.contains(language)
            ? TextDirection.rtl
            : TextDirection.ltr;
      case AppTextDirection.rtl:
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }

  /// 根据系统色选择覆盖层
  SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance.window.platformBrightness;
        break;
    }
    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return overlayStyle;
  }

  AppOptions copyWith({
    ThemeMode themeMode,
    double textScaleFactor,
    AppTextDirection customTextDirection,
    Locale locale,
    double timeDilation,
    TargetPlatform platform,
    bool isTestMode,
  }) {
    return AppOptions(
      themeMode: themeMode ?? this.themeMode,
      textScaleFactor: textScaleFactor ?? _textScaleFactor,
      appTextDirection: customTextDirection ?? this.appTextDirection,
      locale: locale ?? this.locale,
      timeDilation: timeDilation ?? this.timeDilation,
      platform: platform ?? this.platform,
      isTestMode: isTestMode ?? this.isTestMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppOptions &&
      themeMode == other.themeMode &&
      _textScaleFactor == other._textScaleFactor &&
      appTextDirection == other.appTextDirection &&
      locale == other.locale &&
      timeDilation == other.timeDilation &&
      platform == other.platform &&
      isTestMode == other.isTestMode;

  @override
  int get hashCode => hashValues(
        themeMode,
        _textScaleFactor,
        appTextDirection,
        locale,
        timeDilation,
        platform,
        isTestMode,
      );
}

class ApplyTextOptions extends StatelessWidget {
  const ApplyTextOptions({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppOptions options = Provider.of(context);
    final textDirection = options.resolvedTextDirection();
    final textScaleFactor = options.textScaleFactor(context);

    Widget widget = MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: child,
    );

    return textDirection == null
        ? widget
        : Directionality(
            textDirection: textDirection,
            child: widget,
          );
  }
}
