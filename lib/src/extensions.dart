import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:request_builder/request_builder.dart';

extension Sizer on num {
  double get h {
    var h = RequestBuilder.appContext.height;
    return (this / 100) * h;
  }

  double get w {
    var w = RequestBuilder.appContext.width;
    return (this / 100) * w;
  }

  double get sp => this * (RequestBuilder.appContext.width / 3) / 100;
}

extension OnContext on BuildContext {
  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  AppLocalizations? get tr => AppLocalizations.of(this);
}
