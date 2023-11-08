import 'package:dinelah/ui/screens/cart_screen.dart';
import 'package:dinelah/ui/screens/login_screen.dart';
import 'package:dinelah/ui/screens/signup_screen.dart';
import 'package:dinelah/ui/screens/splash_screen2.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../ui/screens/aboutapp.dart';
import '../ui/screens/address/add_address_screen.dart';
import '../ui/screens/address/choose_address.dart';
import '../ui/screens/address/address_screen.dart';

import '../ui/screens/item/order_tracking_behaviour.dart';
import '../ui/screens/wishlist_screen.dart';
import '../ui/screens/bottom_nav_bar.dart';
import '../ui/screens/checkout_screen.dart';
import '../ui/screens/single_product_screen.dart';
import '../ui/screens/menu_screen.dart';
import '../ui/screens/orderdetails.dart';
import '../ui/screens/popupmsg.dart';
import '../ui/screens/privacypolicy.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/support.dart';
import '../ui/screens/terms.dart';
import '../ui/screens/yourorder.dart';

class MyRouter {
  static var addwhishlist = "/addwhishlist";
  static var logInScreen = "/logScreen";
  static var signUpScreen = "/signUpScreen";
  static var profileScreen = "/profileScreen";
  static var aboutapp = "/aboutapp";
  static var myOrdersScreen = "/myOrdersScreen";
  static var privacypolicy = "/privacypolicy";
  static var yourorder = "/yourorder";
  static var term = "/term";
  static var support = "/support";
  static var bottomnavbar = "/bottomnavbar";
  static var popupmsg = "/popupmsg";
  static var trackingOrderBhehviour = "/trackingOrderBhehviour";

  static var route = [
    GetPage(name: '/', page: () => SplashScreen2()),
    // GetPage(name: '/', page: () => const MainHomeScreen()),
    GetPage(name: MainHomeScreen.route, page: () => const MainHomeScreen()),
    GetPage(name: OrderDetails.route, page: () => const OrderDetails()),
    GetPage(name: MyRouter.logInScreen, page: () => const LoginScreen()),
    GetPage(name: MyRouter.signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: MyRouter.popupmsg, page: () => const PopUPScreen()),
    GetPage(name: ChooseAddress.route, page: () => const ChooseAddress()),
    // GetPage(name: OTPVerification.route, page: () => const OTPVerification()),
    GetPage(name: MyRouter.yourorder, page: () => const YourOrderScreen()),
    GetPage(name: CartScreen.route, page: () => const CartScreen()),
    GetPage(name: MyRouter.aboutapp, page: () => const AboutApp()),
    GetPage(name: MyRouter.profileScreen, page: () => const ProfileScreen()),
    GetPage(name: MyRouter.privacypolicy, page: () => const PrivacyPolicy()),
    GetPage(name: AddressScreenn.route, page: () => const AddressScreenn()),
    GetPage(name: AddAddress.route, page: () => const AddAddress()),
    GetPage(name: CheckoutCScreen.route, page: () => const CheckoutCScreen()),
    GetPage(name: MenuScreen.route, page: () => const MenuScreen()),
    GetPage(
        name: SingleProductScreen.route,
        page: () => const SingleProductScreen()),
    GetPage(name: MyRouter.term, page: () => const TermAndCondition()),
    GetPage(name: MyRouter.support, page: () => const SupportScreen()),
    GetPage(name: MyRouter.addwhishlist, page: () => const WishListScreen()),
    GetPage(
        name: trackingOrderBhehviour,
        page: () => const TrackingOrderBhehviour()),
  ];
}
