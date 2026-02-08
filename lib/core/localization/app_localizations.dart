import 'package:flutter/material.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      // General
      'appTitle': 'Meshro3y',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'back': 'Back',
      'logout': 'Logout',
      'settings': 'Settings',

      // Home Screen
      'projects': 'Projects',
      'noProjects': 'No projects yet',
      'addProject': 'Add Project',
      'projectName': 'Project Name',
      'selectMachines': 'Select Machines',

      // Project Details
      'projectDetails': 'Project Details',
      'machines': 'Machines',
      'financialSummary': 'Financial Summary',
      'totalCost': 'Total Cost',
      'totalPaid': 'Total Paid',
      'remaining': 'Remaining',
      'workLogs': 'Work Logs',
      'payments': 'Payments',

      // Work Log Screen
      'workLogScreen': 'Work Logs',
      'addWorkLog': 'Add Work Log',
      'editWorkLog': 'Edit Work Log',
      'deleteWorkLog': 'Delete Work Log',
      'date': 'التاريخ',
      'hoursWorked': 'Hours Worked',
      'totalHours': 'Total Hours',
      'machineNotFound': 'Machine Not Found',
      'areYouSureDelete': 'Are you sure you want to delete the log for',

      // Payment Screen
      'addPayment': 'Add Payment',
      'editPayment': 'Edit Payment',
      'deletePayment': 'Delete Payment',
      'amount': 'Amount',
      'paymentDate': 'Payment Date',
      'totalPayments': 'Total Payments',

      // Owner Screen
      'ownerDetails': 'Owner Details',
      'ownerName': 'Owner Name',
      'ownerPhone': 'Owner Phone',
      'ownerID': 'Owner ID',
      'saveOwner': 'Save Owner',

      // Invoice
      'invoice': 'Invoice',
      'generateInvoice': 'Generate Invoice',
      'previewPdf': 'Preview',
      'downloadPdf': 'Download',
      'sharePdf': 'Share',
      'invoiceDetails': 'Invoice Details',
      'fromDate': 'From Date',
      'toDate': 'To Date',
      'selectDateRange': 'Please select date range first',
      'noWorkLogs': 'No work logs found in selected date range',
      'invoiceNumber': 'Invoice #',
      'issueDate': 'Issue Date',
      'dueDate': 'Due Date',
      'description': 'Description',
      'quantity': 'Quantity',
      'unitPrice': 'Unit Price',
      'subtotal': 'Subtotal',
      'tax': 'Tax',
      'total': 'Total',

      // Validation
      'pleaseEnterHours': 'Please enter hours',
      'pleaseEnterAmount': 'Please enter amount',
      'invalidAmount': 'Invalid amount',
      'invalidPrice': 'Invalid price',
      'invalidHours': 'Invalid hours',
      'pleaseEnterName': 'Please enter your name',
      'pleaseEnterProjectName': 'Please enter project name',
      'selectMachine': 'Please select at least one machine',
      'projectNotFound': 'Project not found',
      'missingOwnerInfo':
          'Missing owner information. Please set up owner details.',
      'fillAllFields': 'Please fill all fields',
      'profileSaved': 'Profile saved successfully',
      'projectCreated': 'Project created successfully',
      'noPayments': 'No payments yet.\nTap + to add your first payment',
      'noMachines': 'No machines yet.\nTap + to add your first machine',
      'noMachinesAvailable':
          'No machines available.\nPlease add machines in Profile first.',
      'noWorkLogsYet': 'No work logs yet.\nTap + to add your first log',
      'deleteConfirm': 'Are you sure you want to delete the payment from',
      'profile': 'Profile',
      'ownerInfo': 'Owner Information',
      'addMachine': 'Add Machine',
      'editMachine': 'Edit Machine',
      'deleteMachine': 'Delete Machine',
      'newProject': 'New Project',
      'invoiceIncludes': 'The invoice will include:',
      'machineBreakdown': 'Machine-wise breakdown',
      'dailyLogs': 'Daily work logs',
      'totalHoursAndCost': 'Total hours and cost',
      'paymentDetails': 'Payment details',
      'remainingBalance': 'Remaining balance',

      // Language
      'language': 'Language',
      'english': 'English',
      'arabic': 'العربية',
    },
    'ar': {
      // General
      'appTitle': 'مشروعي',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'back': 'رجوع',
      'logout': 'تسجيل الخروج',
      'settings': 'الإعدادات',

      // Home Screen
      'projects': 'المشاريع',
      'activeProjects': 'المشاريع النشطة',
      'noProjects': 'لا توجد مشاريع حتى الآن',
      'addProject': 'إضافة مشروع',
      'projectName': 'اسم المشروع',
      'selectMachines': 'اختر الآلات',
      'Date': 'التاريخ',
      'Price per Hour': 'سعر الساعه',
      'Machine Name': 'اسم الاله',
      // Project Details
      'projectDetails': 'تفاصيل المشروع',
      'machines': 'الآلات',
      'financialSummary': 'الملخص المالي',
      'totalCost': 'الإجمالي المستحق',
      'totalPaid': 'المبلغ المدفوع',
      'remaining': 'المتبقي',
      'workLogs': 'سجلات العمل',
      'payments': 'الدفعات',
      'View All': 'عرض الكل',
      // Work Log Screen
      'workLogScreen': 'سجلات العمل',
      'addWorkLog': 'إضافة سجل عمل',
      'editWorkLog': 'تعديل سجل العمل',
      'deleteWorkLog': 'حذف سجل العمل',
      'date': 'التاريخ',
      'hour': 'ساعه',
      'Hours Worked': 'ساعات العمل',
      'totalHours': 'إجمالي الساعات',
      'machineNotFound': 'الآلة غير موجودة',
      'areYouSureDelete': 'هل أنت متأكد من حذف السجل الخاص بـ',
      'Phone Number': 'رقم التليفون',
      'Name': 'الاسم',
      // Payment Screen
      'addPayment': 'إضافة دفعة',
      'editPayment': 'تعديل الدفعة',
      'deletePayment': 'حذف الدفعة',
      'amount': 'المبلغ',
      'paymentDate': 'تاريخ الدفع',
      'totalPayments': 'إجمالي الدفعات',

      // Owner Screen
      'ownerDetails': 'بيانات المالك',
      'ownerName': 'اسم المالك',
      'ownerPhone': 'رقم الهاتف',
      'ownerID': 'رقم الهوية',
      'saveOwner': 'حفظ البيانات',

      // Invoice
      'invoice': 'الفاتورة',
      'generateInvoice': 'إنشاء فاتورة',
      'previewPdf': 'معاينة',
      'downloadPdf': 'تحميل',
      'sharePdf': 'مشاركة',
      'invoiceDetails': 'تفاصيل الفاتورة',
      'fromDate': 'من التاريخ',
      'toDate': 'إلى التاريخ',
      'selectDateRange': 'يرجى اختيار نطاق التاريخ أولاً',
      'noWorkLogs': 'لم يتم العثور على سجلات عمل في نطاق التاريخ المحدد',
      'invoiceNumber': 'رقم الفاتورة',
      'issueDate': 'تاريخ الإصدار',
      'dueDate': 'تاريخ الاستحقاق',
      'description': 'الوصف',
      'quantity': 'الكمية',
      'unitPrice': 'السعر للوحدة',
      'subtotal': 'المجموع الفرعي',
      'tax': 'الضريبة',
      'total': 'الإجمالي',

      // Validation
      'pleaseEnterHours': 'يرجى إدخال الساعات',
      'invalidHours': 'ساعات غير صحيحة',
      'pleaseEnterAmount': 'يرجى إدخال المبلغ',
      'invalidAmount': 'مبلغ غير صحيح',
      'invalidPrice': 'سعر غير صحيح',
      'pleaseEnterName': 'يرجى إدخال اسمك',
      'pleaseEnterProjectName': 'يرجى إدخال اسم المشروع',
      'selectMachine': 'يرجى تحديد آلة واحدة على الأقل',
      'projectNotFound': 'المشروع غير موجود',
      'missingOwnerInfo': 'بيانات المالك ناقصة. يرجى إعداد بيانات المالك.',
      'fillAllFields': 'يرجى ملء جميع الحقول',
      'profileSaved': 'تم حفظ الملف الشخصي بنجاح',
      'projectCreated': 'تم إنشاء المشروع بنجاح',
      'noPayments': 'لا توجد دفعات حتى الآن.',
      'noMachines': 'لا توجد آلات حتى الآن.',
      'noMachinesAvailable': 'لا توجد آلات متاحة.',
      'noWorkLogsYet': 'لا توجد سجلات عمل حتى الآن.',
      'deleteConfirm': 'هل أنت متأكد من حذف',
      'profile': 'الملف الشخصي',
      'ownerInfo': 'بيانات المالك',
      'addMachine': 'إضافة آلة',
      'editMachine': 'تعديل الآلة',
      'deleteMachine': 'حذف الآلة',
      'newProject': 'مشروع جديد',
      'invoiceIncludes': 'ستتضمن الفاتورة:',
      'machineBreakdown': 'تفصيل الآلات',
      'dailyLogs': 'سجلات العمل اليومية',
      'totalHoursAndCost': 'إجمالي الساعات والتكلفة',
      'paymentDetails': 'تفاصيل الدفع',
      'remainingBalance': 'الرصيد المتبقي',

      // Language
      'language': 'اللغة',
      'english': 'English',
      'arabic': 'العربية',
    }
  };

  static String _currentLocale = 'ar'; // Arabic as default

  static String get currentLocale => _currentLocale;

  static void setLocale(String locale) {
    _currentLocale = locale;
  }

  static String get(String key) {
    return _localizedStrings[_currentLocale]?[key] ?? key;
  }

  static Locale getLocale() {
    return Locale(_currentLocale);
  }

  static List<Locale> getSupportedLocales() {
    return const [
      Locale('en'),
      Locale('ar'),
    ];
  }
}

// Extension for easy access
extension LocalizationExtension on String {
  String get tr => AppLocalizations.get(this);
}
