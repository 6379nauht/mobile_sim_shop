class Routes {
  Routes._(); // Private constructor to prevent instantiation
  // Thêm route khởi đầu
  static const String initialRoute = '/';

  ///Authentication Path
  static const signin = '/signin';
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


  ///Personalization Path
  static const settings = '/settings';
  static const profile = '/profile';
  static const address = '/address';
  static const addNewAddress = '/add_new_address';

  ///Personalization Name
  static const profileName = 'profile';
  static const addressName = 'address';
  static const addNewAddressName = 'add_new_address';



  ///Store Path
  static const home = '/home';
  static const store = '/store';
  static const wishlist = '/wishlist';
  static const productDetails = '/product_details';
  static const cart = '/cart';
  static const checkout = '/check_out';
  static const checkoutSuccess = '/check_out_success';
  static const order = '/order';
  static const subCategories= '/sub_categories';

  ///Store Name
  static const homeName = 'home';
  static const storeName = 'store';
  static const productDetailsName = 'product_details';
  static const cartName = 'cart';
  static const checkoutName = 'check_out';
  static const checkoutSuccessName = 'check_out_success';
  static const orderName = 'order';
  static const subCategoriesName = 'sub_categories';





  // List of all routes for easy access in NavigationMenu
  static const List<String> all = [
    home,
    store,
    wishlist,
    settings,
  ];
}