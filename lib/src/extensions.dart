import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:request_builder/lang.dart';
import 'package:request_builder/request_builder.dart';

extension Sizer on num {
  BuildContext get context =>
      RequestBuilderInitializer.instance.navigatorKey!.currentContext!;

  double get h {
    var h = context.height;
    return (this / 100) * h;
  }

  double get w {
    var w = context.width;
    return (this / 100) * w;
  }

  double get sp => this * (context.width / 3) / 100;
}

extension OnContext on BuildContext {
  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  bool get isEn => Localizations.localeOf(this).languageCode == 'en';

  Lang get lng => isEn ? LangEn() : LangAr();
}
