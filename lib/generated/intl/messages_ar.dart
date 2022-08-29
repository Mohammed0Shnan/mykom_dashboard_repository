import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "login": MessageLookupByLibrary.simpleMessage("دخول"),
        "email": MessageLookupByLibrary.simpleMessage("الايميل"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة السر"),
        "createAccount": MessageLookupByLibrary.simpleMessage("انشاء حساب"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("تأكيد كلمة السر"),
        "register": MessageLookupByLibrary.simpleMessage("تسجيل"),
        "logout": MessageLookupByLibrary.simpleMessage("خروج"),
        "language": MessageLookupByLibrary.simpleMessage("اللغة"),
        "english": MessageLookupByLibrary.simpleMessage("الانكليزية"),
        "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "setting": MessageLookupByLibrary.simpleMessage("الاعدادات"),
        "products": MessageLookupByLibrary.simpleMessage("المنتجات"),
                "myProducts": MessageLookupByLibrary.simpleMessage("منتجاتي"),

        "filterName": MessageLookupByLibrary.simpleMessage("الاسم"),
        "filterCategory": MessageLookupByLibrary.simpleMessage("التصنيف"),
        "filterDate": MessageLookupByLibrary.simpleMessage("التاريخ"),
        "detailProduct": MessageLookupByLibrary.simpleMessage("تفاصيل المنتج"),
        "productName": MessageLookupByLibrary.simpleMessage("اسم المنتج"),
        "category": MessageLookupByLibrary.simpleMessage("التصنيف"),
        "quantity": MessageLookupByLibrary.simpleMessage("الكمية"),
        "expiredDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
        "price": MessageLookupByLibrary.simpleMessage("السعر"),
        "contectInfo": MessageLookupByLibrary.simpleMessage("معلومات التواصل"),
      };
}
