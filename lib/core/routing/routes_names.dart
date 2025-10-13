import 'package:flutter/material.dart';

import '../../features/home/presentation/screens/home_page.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/app_text.dart';

class RoutesNames {
  static const String splashScreen = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String otp = '/sing_up';
  static const String transactions = '/transactions';
}

///on generate route search for rout "/" if found return screen
///if not found return not found screen
///we don't use initialRoute with onGenerateRoute because onGenerateRoute
///can be called multiple times,its run "/" and then initalRoute
Route onGenerateRoute(RouteSettings settings) {
  // final receiptData = ReceiptData.fromJson(fakeReceiptJson);
  switch (settings.name) {
    case RoutesNames.splashScreen:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case RoutesNames.home:
      return MaterialPageRoute(builder: (_) => const HomePage());

    default:
      return MaterialPageRoute(
        builder:
            (_) =>
                const Scaffold(body: Center(child: AppText(text: 'NOT FOUND'))),
      );
  }
}

// // 1) حط الـ JSON كما هو (fake data)
const fakeReceiptJson = {
  "id": "34bfaa3f-4654-4ad4-bbed-bb383534ce8c",
  "merchant": {
    "id": "100000000000001",
    "name": {
      "arabic": "NearPay Merchant Arabic",
      "english": "NearPay Merchant",
    },
    "address": {"arabic": "4321", "english": "KAFD"},
    "category_code": "0763",
  },
  "card_scheme": {
    "name": {"english": "Visa", "arabic": "فيزا"},
    "id": "VC",
  },
  "card_scheme_sponsor": "INMA",
  "start_date": "14/08/2025",
  "start_time": "13:37:55",
  "end_date": "14/08/2025",
  "end_time": "13:37:55",
  "tid": "0211646700116467",
  "system_trace_audit_number": "000017",
  "pos_software_version_number": "1.0.0",
  "retrieval_reference_number": "570259000000",
  "transaction_type": {
    "name": {"arabic": "شراء", "english": "PURCHASE"},
    "id": "00",
  },
  "is_approved": true,
  "is_refunded": false,
  "is_reversed": false,
  "approval_code": {
    "value": "664809",
    "label": {"arabic": "رمز الموافقة", "english": "Approval Code"},
  },
  "action_code": "000",
  "status_message": {"arabic": "مقبولة", "english": "Approved"},
  "pan": "4829 15** ** 0935",
  "card_expiration": "29/03",
  "amount_authorized": {
    "label": {"arabic": "مبلغ الشراء", "english": "PURCHASE AMOUNT"},
    "value": "14.55",
  },
  "amount_other": {
    "label": {"arabic": "مبلغ النقد", "english": "NAQD AMOUNT"},
    "value": "0.00",
  },
  "currency": {"arabic": "ر.س", "english": "SAR"},
  "verification_method": {
    "english": "DEVICE OWNER IDENTITY VERIFIED",
    "arabic": "تم التحقق من هوية حامل الجهاز ",
  },
  "receipt_line_one": {"arabic": "", "english": ""},
  "receipt_line_two": {"arabic": "", "english": ""},
  "thanks_message": {
    "arabic": "شكرا لاستخدامكم مدى",
    "english": "Thank you for using mada",
  },
  "save_receipt_message": {
    "arabic": "يرجى الاحتفاظ بالفاتورة",
    "english": "please retain receipt",
  },
  "entry_mode": "CONTACTLESS",
  "application_identifier": "A0000000031010",
  "terminal_verification_result": "2480400080",
  "transaction_state_information": "0000",
  "cardholader_verfication_result": "1F0000",
  "cryptogram_information_data": "80",
  "application_cryptogram": "82DE8706EFDF4089",
  "kernel_id": "03",
  "payment_account_reference": "V0010013021088567550590138607",
  "pan_suffix": "",
  "customer_reference_number": null,
  "qr_code":
      "https://sandbox-api.nearpay.io/ui/receipt/34bfaa3f-4654-4ad4-bbed-bb383534ce8c",
  "transaction_uuid": "a53a88c6-0017-4aa1-b5ab-2092973350c6",
  "vas_data": null,
};
