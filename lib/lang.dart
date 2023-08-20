abstract class Lang {
  String get ok;

  String get retry;

  String get loading;

  String get error;

  String get success;

  String get noData;
}

class LangAr implements Lang {
  @override
  String get error => "خطأ";

  @override
  String get loading => "جاري التحميل";

  @override
  String get noData => "لا توجد بيانات";

  @override
  String get ok => "حسنا";

  @override
  String get retry => "اعد المحاولة";

  @override
  String get success => "تم بنجاح";
}

class LangEn implements Lang {
  @override
  String get error => "Error";

  @override
  String get loading => "Loading";

  @override
  String get noData => "There is no data";

  @override
  String get ok => "Ok";

  @override
  String get retry => "Retry";

  @override
  String get success => "Success";
}
