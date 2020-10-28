import 'package:get/get.dart';

class Messages extends Translations {
  static const String login_button = 'key_login_button';
  static const String signup_button = 'key_signup_button';
  static const String login_heading = 'key_login_heading';
  static const String signup_heading = 'key_signup_heading';
  static const String input_email = 'key_email';
  static const String input_password = 'key_password';
  static const String input_name = 'key_name';
  static const String unable_login = 'key_unable_login';
  static const String unable_signup = 'key_unable_signup';
  static const String unable_logout = 'key_unable_logout';
  static const String home_screen_heading = 'key_home_screen_heading';
  static const String show_favorites = 'key_show_favorites';
  static const String show_all = 'key_show_all';
  static const String welcome_everyone = 'key_welcome_everyone';
  static const String shop_screen_text = 'key_shop';
  static const String orders_screen_text = 'key_orders';
  static const String user_product_screen_text = 'key_user_product';
  static const String logout = 'key_log_out';

  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'en_US': <String, String>{
          login_button: 'Login',
          signup_button: 'Signup',
          login_heading: 'Login',
          signup_heading: 'Signup',
          input_email: 'Email',
          input_password: 'Password',
          input_name: 'Full Name',
          unable_login: "Unable to login : ",
          unable_signup: "Unable to signup : ",
          home_screen_heading: "MyShop",
          show_favorites: "Only Favorites",
          show_all: "Show All",
          welcome_everyone: "Welcome",
          shop_screen_text: "Shop",
          orders_screen_text: "View Orders",
          user_product_screen_text: "Manage Orders",
          logout: "Logout",
          unable_logout: "Unable to Logout : ",
        },
        'hi_IN': <String, String>{
          login_button: 'लॉग इन करें',
          signup_button: 'साइन अप करें',
          login_heading: 'लॉग इन करें',
          signup_heading: 'साइन अप करें',
          input_email: 'ईमेल',
          input_password: 'कुंजिका',
          input_name: 'पूरा नाम',
          unable_login: "लॉग इन करने में असमर्थ रहा : ",
          unable_signup: "साइनअप करने में असमर्थ : ",
          home_screen_heading: "मेरी दुकान",
          show_favorites: "केवल पसंदीदा",
          show_all: "सब दिखाओ",
          welcome_everyone: "स्वागत है",
          shop_screen_text: "दुकान",
          orders_screen_text: "आदेश देखें",
          user_product_screen_text: "आदेश प्रबंधित करें",
          logout: "लॉग आउट",
          unable_logout: "लॉगआउट करने में असमर्थ : ",
        }
      };
}
