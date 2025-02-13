import 'package:flutter/material.dart';
import 'package:mobile_sim_shop/core/utils/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo ScreenUtil đúng cách, nhận BuildContext trong builder
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo ScreenUtil trong builder của MaterialApp với BuildContext
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      builder: (_, child) {
        return child!;
      },
      home: const LoginPage(), // HomePage của bạn ở đây
    );
  }
}
