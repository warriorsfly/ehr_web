import 'package:flutter/material.dart';

abstract class EhrLocalization {
  final String locale;

  EhrLocalization({@required this.locale});

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN')
  ];
}
