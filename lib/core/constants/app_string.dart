class AppMessage {
  static const String appName = 'JAAYEK RESTAURANT';
  static const String mandatoryTx = 'هذا الحقل مطلوب';
  static const String invalidPhone = "رقم الجوال غير صالح";
  static const String notStart0 = "يجب ان يبدا الرقم ب5";
  static const String loginText = "تسجيل الدخول";
  static const String phone = "رقم الجوال";
  static const String success = "نجاح";
  static const String warning = "تحذير";
  static const String error = "خطأ";
  static const String info = "معلومة";
  static const String verifyPhone = "أدخل رمز التحقق";
  static const String verifyPhoneText =
      "تم إرسال رمز التحقق إلى رقم الجوال الخاص بك";
  static const String fillAll = "الرجاء إدخال الرمز الكامل";
  static const String codeDidNotArrive = "لم يصلك الرمز؟ أعد الإرسال";
  static const String verify = "تحقق";

  static const String logout = "تسجيل الخروج";
  static const String price = "السعر";
  static const String cansel = "الغاء";
  static const String cancel = "إلغاء";
  static const String confirm = "تأكيد";
  static const String settings = "الإعدادات";
  static const String ok = "حسنا";
  static const String wrong = "حدث خطا ما";
  // Error Messages
  static const String unAuthorizedText =
      'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مجددًا';
  static const String tryAgain = 'إعادة المحاولة';
  static const String serverText =
      "حدث خطأ غير متوقع من الخادم. يرجى المحاولة لاحقًا";
  static const String socketText =
      'تعذّر الاتصال بالخادم. يرجى التحقق من الاتصال والمحاولة لاحقًا';
  static const String timeoutText =
      'يبدو أن الخادم يستغرق وقتًا طويلاً للاستجابة، حاول مجدداً بعد فترة';
  static const String formatText = "تعذر إتمام العملية في الوقت الحالي.";
  static const String socketError =
      "لا يوجد اتصال بالإنترنت حالياً، يرجى التحقق من الشبكة لإكمال استخدام التطبيق.";
  static const String noHaveAccount = "ليس لديك حساب؟ انشاء الحساب";
  static const String haveAccount = "لديك حساب؟ تسجيل الدخول";
  static const String password = "كلمة المرور";
  static const String confirmPassword = "تأكيد كلمة المرور";
  static const String singUpText = "انشاء حساب";
  static const String name = "اسم المطعم";
  static const String supervisor = "اسم المشرف";
  static const String email = "البريد الالكتروني";
  static const String foodMenu = "قائمة الطعام";
  static const String orders = "الطلبات";
  static const String profile = "الحساب";

  // Food Menu Strings
  static const String customizable = "قابل للتخصيص";
  static const String notAvailableTemp = "غير متاح مؤقتًا";
  static const String edit = "تعديل";
  static const String delete = "حذف";
  static const String deleteMeal = "حذف الطبق؟";
  static const String deleteMealConfirm =
      "هل أنت متأكد أنك تريد حذف هذه الطبق؟ لا يمكن التراجع.";
  static const String noDishesYet = "لا توجد أطباق بعد";
  static const String addFirstDish = "أضف أول طبق لبدء عرض قائمتك هنا.";
  static const String addMeal = "إضافة طبق جديد";
  static const String searchForMeal = "ابحث عن طبق معين...";
  static const String all = "الكل";
  static const String sar = "د.ا";
  static const String addNewCategory = "إضافة فئة جديدة";
  static const String categoryName = "اسم الفئة";
  static const String enterName = "أدخل الاسم";
  static const String add = "إضافة";
  static const String createAddonGroup = "إنشاء مجموعة إضافات";
  static const String groupName = "اسم المجموعة";
  static const String required = "إلزامي";
  static const String maxSelections = "الحد الأقصى للاختيارات";
  static const String addItemToList = "إضافة عنصر إلى القائمة";
  static const String itemName = "اسم العنصر";
  static const String enterPrice = "أدخل السعر";
  static const String editMeal = "تعديل معلومات الطبق";
  static const String mealName = "اسم الطبق";
  static const String description = "الوصف";
  static const String category = "الفئة";
  static const String chooseCategory = "اختر الفئة";
  static const String branch = "الفرع";
  static const String chooseBranch = "اختر الفرع";
  static const String available = "متاح";
  static String goToSettings = 'الذهاب للاعدادات';
  static const String canCustomize = "قابل للتخصيص";
  static const String saveChanges = "حفظ التعديلات";
  static const String save = "حفظ";
  static const String enterMealName = "يرجى إدخال الاسم";
  static const String enterDescription = "يرجى إدخال الوصف";
  static const String enterMealPrice = "يرجى إدخال السعر";
  static const String mealPhoto = 'اضغط لاختيار صورة الطبق';
  static const String imageRequired = 'يجب اختيار صورة للطبق';
  static const String enablePermission = 'تفعيل الاذن';
  static String permissionRequest({required String permissionType}) {
    return 'الرجاء تفعيل اذن $permissionType لتتمكن من اكمال العملية ';
  }

  static const String imageReachedLimit =
      'حجم الصورة يجب أن لا يزيد عن 1 ميجابايت';
  static const String accessImage =
      "التطبيق يحتاج إلى إذن لعرض الصور، فعل الإذن من الإعدادات.";
  static const String micPermissionMessage =
      'يجب تفعيل إذن الميكروفون لاستخدام هذه الميزة. الرجاء تفعيل الإذن من الإعدادات.';
  static const String micPermission = 'تفعيل اذن المايكروفون';

  // Orders Strings
  static const String newOrders = 'طلبات جديدة';
  static const String allOrders = 'كل الطلبات';
  static const String orderDetails = 'تفاصيل الطلب';
  static const String orderNumber = 'رقم الطلب';
  static const String customer = 'معلومات العميل';
  static const String customerName = 'اسم العميل';
  static const String customerPhone = 'رقم العميل';
  static const String customerAddress = 'عنوان التوصيل';
  static const String orderItems = 'المنتجات';
  static const String orderNotes = 'ملاحظات الطلب';
  static const String orderTime = 'وقت الطلب';
  static const String estimatedTime = 'وقت التوصيل المتوقع';
  static const String orderTotal = 'المجموع الكلي';
  static const String subtotal = 'المجموع الفرعي';
  static const String deliveryFee = 'رسوم التوصيل';
  static const String paymentMethod = 'طريقة الدفع';
  static const String paid = 'مدفوع';
  static const String notPaid = 'غير مدفوع';

  // Order Status
  static const String statusPending = 'طلب جديد';
  static const String statusConfirmed = 'مؤكد';
  static const String statusPreparing = 'قيد التحضير';
  static const String statusReady = 'جاهز';
  static const String statusOnTheWay = 'في الطريق';
  static const String statusDelivered = 'تم التسليم';
  static const String statusCancelled = 'ملغي';

  // Order Actions
  static const String acceptOrder = 'قبول الطلب';
  static const String rejectOrder = 'رفض الطلب';
  static const String markAsPreparing = 'بدء التحضير';
  static const String markAsReady = 'جاهز للتوصيل';
  static const String markAsOnTheWay = 'تم تسليم الطلب الى السائٍق';
  static const String estimatedPrepTime = 'وقت التحضير المتوقع (بالدقائق)';
  static const String enterEstimatedTime = 'أدخل الوقت المتوقع';
  static const String rejectionReason = 'سبب الرفض (اختياري)';
  static const String enterRejectionReason = 'أدخل سبب رفض الطلب';
  static const String confirmAccept = 'تأكيد القبول';
  static const String confirmReject = 'تأكيد الرفض';
  static const String acceptOrderMessage = 'هل أنت متأكد من قبول هذا الطلب؟';
  static const String rejectOrderMessage = 'هل أنت متأكد من رفض هذا الطلب؟';
  static const String updateStatusMessage = 'هل تريد تحديث حالة الطلب؟';
  static const String orderAccepted = 'تم قبول الطلب بنجاح';
  static const String orderRejected = 'تم رفض الطلب';
  static const String orderUpdated = 'تم تحديث حالة الطلب';
  static const String noOrdersYet = 'لا توجد طلبات بعد';
  static const String noOrdersMessage = 'عندما تتلقى طلبات جديدة، ستظهر هنا';
  static const String refreshOrders = 'تحديث الطلبات';
  static const String items = 'عناصر';
  static const String item = 'عنصر';
  static const String addons = 'إضافات';
  static const String quantity = 'الكمية';
  static const String minutes = 'دقيقة';

  // Wallet & Transactions Strings
  static const String wallet = 'المحفظة';
  static const String balance = 'الرصيد المتاح';
  static const String totalEarnings = 'إجمالي الإيرادات';
  static const String totalWithdrawals = 'إجمالي المسحوبات';
  static const String pendingAmount = 'قيد المعالجة';
  static const String allTransactions = 'كل العمليات';
  static const String earnings = 'الإيرادات';
  static const String withdrawals = 'المسحوبات';
  static const String commissions = 'العمولات';
  static const String requestWithdrawal = 'طلب سحب';
  static const String withdrawalAmount = 'مبلغ السحب';
  static const String bankAccount = 'الحساب البنكي';
  static const String transactionDetails = 'تفاصيل العملية';
  static const String transactionType = 'نوع العملية';
  static const String transactionStatus = 'حالة العملية';
  static const String transactionDate = 'تاريخ العملية';
  static const String reference = 'الرقم المرجعي';
  static const String noTransactions = 'لا توجد عمليات';
  static const String noTransactionsMessage = 'لم تتم أي عمليات مالية بعد';

  // Add-ons Strings
  static const String addAddon = 'إضافة إضافة جديدة';
  static const String editAddon = 'تعديل الإضافة';
  static const String deleteAddon = 'حذف الإضافة';
  static const String addonName = 'اسم الإضافة';
  static const String addonDescription = 'وصف الإضافة';
  static const String addonPrice = 'سعر الإضافة';
  static const String unitType = 'نوع الوحدة';
  static const String chooseUnitType = 'اختر نوع الوحدة';
  static const String piece = 'قطعة';
  static const String kilogram = 'كيلو';
  static const String gram = 'جرام';
  static const String noAddonsYet = 'لا توجد إضافات بعد';
  static const String noAddonsMessage = 'أضف أول إضافة لبدء عرض قائمتك هنا.';
  static const String addonCreated = 'تم إنشاء الإضافة بنجاح';
  static const String addonUpdated = 'تم تحديث الإضافة بنجاح';
  static const String addonDeleted = 'تم حذف الإضافة بنجاح';
  static const String deleteAddonConfirm = 'حذف الإضافة؟';
  static const String deleteAddonMessage =
      'هل أنت متأكد أنك تريد حذف هذه الإضافة؟ لا يمكن التراجع.';
  static const String enterAddonName = 'يرجى إدخال اسم الإضافة';
  static const String enterAddonDescription = 'يرجى إدخال وصف الإضافة';
  static const String enterAddonPrice = 'يرجى إدخال سعر الإضافة';
  static const String chooseAddonUnitType = 'يرجى اختيار نوع الوحدة';
  static const String done = 'تمت  العمليه بنجاح';

  // Categories Strings
  static const String categories = 'الفئات';
  static const String meals = 'الأطباق';
  static const String addCategory = 'إضافة فئة جديدة';
  static const String noCategoriesYet = 'لا توجد فئات بعد';
  static const String noCategoriesMessage = 'أضف أول فئة لبدء عرض قائمتك هنا.';
  static const String categoryCreated = 'تم إنشاء الفئة بنجاح';
  static const String categoryUpdated = 'تم تحديث الفئة بنجاح';
  static const String categoryDeleted = 'تم حذف الفئة بنجاح';
  static const String deleteCategoryConfirm = 'حذف الفئة؟';
  static const String deleteCategoryMessage =
      'هل أنت متأكد أنك تريد حذف هذه الفئة؟ لا يمكن التراجع.';
  static const String enterCategoryName = 'يرجى إدخال اسم الفئة';
  static const String enterCategoryNameAr = 'يرجى إدخال اسم الفئة بالعربية';
  static const String editCategory = 'تعديل الفئة';
  static const String selectImage = 'اختر صورة';
  static const String changeImage = 'تغيير الصورة';
  static const String imageSizeExceedsLimit =
      'حجم الصورة يتجاوز 1 ميجابايت. الرجاء اختيار صورة أصغر';
  static const String errorCheckingImageSize =
      'حدث خطأ أثناء التحقق من حجم الصورة';
  static const String selectImageSource = 'اختر مصدر الصورة';
  static const String photoLibrary = 'مكتبة الصور';
  static const String files = 'الملفات';

  // Login Validation Messages
  static const String noBranchAssigned = 'لم يتم إسناد فرع لهذا المستخدم';
  static const String noBranchAssignedMessage =
      'لم يتم إسناد فرع لهذا المستخدم. الرجاء التواصل مع الجهة المسؤولة.';

  // Addon Groups Strings
  static const String addonGroups = 'مجموعات الإضافات';
   static const String groupTitle = 'عنوان المجموعة';
  static const String enterGroupTitle = 'يرجى إدخال عنوان المجموعة';
  static const String selectionType = 'نوع الاختيار';
  static const String singleSelection = 'اختيار واحد';
  static const String multipleSelection = 'اختيار متعدد';
  static const String maxSelectable = 'الحد الأقصى للاختيارات';
  static const String allowQuantity = 'السماح باختيار الكمية';
   static const String optional = 'اختياري';
  static const String addonItems = 'خيارات الإضافة';
  static const String addItem = 'إضافة خيار';
   static const String itemDescription = 'وصف الخيار (اختياري)';
  static const String itemPrice = 'سعر الخيار';
  static const String itemImage = 'صورة الخيار (اختياري)';
  static const String editGroup = 'تعديل المجموعة';
  static const String deleteGroup = 'حذف المجموعة';
  static const String editItem = 'تعديل الخيار';
  static const String deleteItem = 'حذف الخيار';
  static const String noItems = 'لا توجد خيارات';
  static const String addFirstItem = 'أضف أول خيار';
}
