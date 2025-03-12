class Routes {
  Routes._(); // Private constructor to prevent instantiation

  ///Authentication
  static const signin = '/';
  static const signup = '/signup';
  static const forgetPassword = '/forget_password';
  static const resetPassword = '/reset_password';
  static const verifyEmail = '/verify_email';
  static const verifySuccess = '/verify_success';

  ///Authentication Name
  static const signinName = 'signin';
  static const signupName = 'signup';
  static const forgetPasswordName = 'forget_password';
  static const resetPasswordName = 'reset_password';
  static const verifyEmailName = 'verify_email';
  static const verifySuccessName = 'verify_success';


  static const home = '/home';
  static const store = '/store';
  static const orders = '/orders';
  static const settings = '/settings';
  static const profile = '/profile';

  static const homeName = 'home';
  static const profileName = 'profile';
  static const storeName = 'store';






  // List of all routes for easy access in NavigationMenu
  static const List<String> all = [
    home,
    store,
    orders,
    settings
  ];
}