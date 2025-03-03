import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/network/network_bloc.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/check_email_verification_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/save_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signup_usecase.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search_day_year/search_day_year_bloc.dart';

import 'core/utils/theme/app_theme.dart';
import 'features/auth/presentation/blocs/signin/signin_event.dart';
import 'features/auth/presentation/pages/signin/signin.dart';

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

    return MultiBlocProvider(
      providers: [
        ///Network
        BlocProvider<NetworkBloc>(
          create: (_) => NetworkBloc(),
        ),

        ///Signup
        BlocProvider<SignupBloc>(
            create: (_) => SignupBloc(
                getIt<SignupUseCase>(),
                getIt<DeleteUserUsecase>(),
                getIt<CheckEmailVerifiedUsecase>())),

        ///Signin
        BlocProvider<SigninBloc>(
            create: (_) => SigninBloc(
                getIt<GetRememberMeUseCase>(), getIt<SaveRememberMeUseCase>())
              ..add(LoadRememberMe())),

        ///Carousel
        BlocProvider<CarouselBloc>(
          create: (_) => CarouselBloc(),
        ),

        ///Search
        BlocProvider<SearchDayYearBloc>(
          create: (_) => SearchDayYearBloc(),
        )
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        builder: (_, child) {
          return child!;
        },
        home: const SigninPage(), // HomePage của bạn ở đây
      ),
    );
  }
}
