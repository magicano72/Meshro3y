import 'package:Meshro3y/presentation/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/models/machine_model.dart';
import 'data/models/owner_model.dart';
import 'data/models/payment_model.dart';
import 'data/models/project_model.dart';
import 'data/models/work_log_model.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(OwnerModelAdapter());
  Hive.registerAdapter(MachineModelAdapter());
  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(WorkLogModelAdapter());
  Hive.registerAdapter(PaymentModelAdapter());

  // Open Boxes with error handling for migration
  try {
    await Hive.openBox<OwnerModel>(AppConstants.ownerBox);
  } catch (e) {
    // Clear owner box if there's a compatibility issue
    await Hive.deleteBoxFromDisk(AppConstants.ownerBox);
    await Hive.openBox<OwnerModel>(AppConstants.ownerBox);
  }

  await Hive.openBox<MachineModel>(AppConstants.machineBox);
  await Hive.openBox<ProjectModel>(AppConstants.projectBox);
  await Hive.openBox<WorkLogModel>(AppConstants.workLogBox);
  await Hive.openBox<PaymentModel>(AppConstants.paymentBox);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(languageProvider);

    // Map language code to full locale with country code
    final localeMap = {
      'ar': const Locale('ar', 'SA'),
      'en': const Locale('en', 'US'),
    };

    final locale = localeMap[languageCode] ?? const Locale('ar', 'SA');

    return MaterialApp(
      title: 'Meshro3y',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainNavigationScreen(),
    );
  }
}
