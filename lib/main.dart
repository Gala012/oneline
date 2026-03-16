import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_line/pages/one_line_library/one_line_library_binding.dart';
import 'package:one_line/pages/one_line_library/one_line_library_view.dart';
import 'package:one_line/pages/one_line_mood/one_line_mood_inside.dart';
import '../pages/one_line_tab/one_line_tab_binding.dart';
import '../pages/one_line_tab/one_line_tab_view.dart';
import '../pages/one_line_home/one_line_home_binding.dart';
import '../pages/one_line_home/one_line_home_view.dart';
import '../pages/one_line_compose/one_line_compose_binding.dart';
import '../pages/one_line_compose/one_line_compose_view.dart';
import '../pages/one_line_mood/one_line_mood_binding.dart';
import '../pages/one_line_mood/one_line_mood_view.dart';
import '../pages/one_line_archive/one_line_archive_binding.dart';
import '../pages/one_line_archive/one_line_archive_view.dart';
import '../pages/one_line_success/one_line_success_binding.dart';
import '../pages/one_line_success/one_line_success_view.dart';
import '../pages/one_line_explore/one_line_explore_binding.dart';
import '../pages/one_line_explore/one_line_explore_view.dart';
import '../pages/one_line_theme/one_line_theme_binding.dart';
import '../pages/one_line_theme/one_line_theme_view.dart';
import '../pages/one_line_mood_calendar/one_line_mood_calendar_binding.dart';
import '../pages/one_line_mood_calendar/one_line_mood_calendar_view.dart';
import 'db_one_line/data.dart';
import 'services/quote_service.dart';
import 'services/inspiration_service.dart';

const Color primaryColor = Color(0xFF0F0F0F);
const Color bgColor = Color(0xFFFFFFFF);
const Color textColor = Color(0xFF0F0F0F);
const Color subtleColor = Color(0xFF6B7280);
const Color dividerColor = Color(0xFFE5E7EB);
const Color cardBgColor = Color(0xFFFAFAFA);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync(() async => DbOneLine());
  await Get.putAsync(() async => QuoteService());
  await Get.putAsync(() async => InspirationService());
  final quoteService = Get.find<QuoteService>();
  await quoteService.initializePresetQuotes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Lines,
          initialRoute: '/',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              surface: Color(0xFFFFFFFF),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF0F0F0F),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(size: 22, color: Color(0xFF0F0F0F)),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Color(0xFF0F0F0F),
              unselectedItemColor: Color(0xFF9CA3AF),
              elevation: 0,
              backgroundColor: Color(0xFFFFFFFF),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            dividerTheme: const DividerThemeData(
              thickness: 1,
              color: Color(0xFFE5E7EB),
            ),
          ),
        );
      },
    );
  }
}
List<GetPage<dynamic>> Lines = [
  GetPage(
    name: '/',
    page: () => const OneLineLibraryView(),
    binding: OneLineLibraryBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_tab',
    page: () => const OneLineTabView(),
    binding: OneLineTabBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_home',
    page: () => const OneLineHomeView(),
    binding: OneLineHomeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_compose',
    page: () => const OneLineComposeView(),
    binding: OneLineComposeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_mood',
    page: () => const OneLineMoodView(),
    binding: OneLineMoodBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_mood_side',
    page: () => const OneLineMoodInside(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_archive',
    page: () => const OneLineArchiveView(),
    binding: OneLineArchiveBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_success',
    page: () => const OneLineSuccessView(),
    binding: OneLineSuccessBinding(),
    transition: Transition.fadeIn,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_explore',
    page: () => const OneLineExploreView(),
    binding: OneLineExploreBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_theme',
    page: () => const OneLineThemeView(),
    binding: OneLineThemeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/one_mood_calendar',
    page: () => const OneLineMoodCalendarView(),
    binding: OneLineMoodCalendarBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
];