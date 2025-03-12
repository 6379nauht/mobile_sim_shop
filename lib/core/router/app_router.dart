import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signin/signin.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signup/signup.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/profile.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/settings/settings.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/home.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/store/store.dart';

import '../../features/auth/presentation/pages/password_configuration/forget_password.dart';
import '../../features/auth/presentation/pages/password_configuration/reset_password.dart';
import '../../features/auth/presentation/pages/signup/verify_email.dart';
import '../../navigation_menu.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_strings.dart';
import '../widgets/success_page/success_page.dart';

class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  // Make router a static field so it can be accessed without creating an instance
  static final GoRouter router = GoRouter(
    initialLocation: Routes.signin,
    routes: [
      GoRoute(
          path: Routes.signin,
          name: Routes.signinName,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SigninPage())),

      GoRoute(
        path: Routes.signup,
        name: Routes.signupName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SignupPage()),
      ),
      GoRoute(
        path: Routes.forgetPassword,
        name: Routes.forgetPasswordName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ForgetPasswordPage()),
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: Routes.resetPasswordName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ResetPasswordPage()),
      ),
      GoRoute(
        path: Routes.verifyEmail,
        name: Routes.verifyEmailName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: VerifyEmailPage()),
      ),
      GoRoute(
        path: Routes.verifySuccess,
        name: Routes.verifySuccessName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: SuccessPage(
            image: AppImages.success,
            title: AppTexts.accountSuccessTitle,
            subTitle: AppTexts.accountSuccessSubTitle,
            onPressed: () => context.goNamed(Routes.signin),
          ),
        ),
      ),

      GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          pageBuilder: (_, state) =>
              const NoTransitionPage(child: ProfilePage())),

      ///BottomNavigation
      ShellRoute(
        builder: (context, state, child) {
          return NavigationMenu(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.home,
            name: Routes.homeName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: Routes.store,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StorePage(),
            ),
          ),
          GoRoute(
              path: Routes.settings,
              pageBuilder: (_, state) =>
                  const NoTransitionPage(child: SettingsPage()))
        ],
      ),
    ],
  );
}
