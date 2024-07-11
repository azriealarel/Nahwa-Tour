import 'package:flutter/material.dart';
import 'package:travelappui/models/placesModel.dart';
import 'package:travelappui/views/HomePage/homepage.dart';
import 'package:travelappui/views/SplashScreen/splashscreen.dart';
import 'package:travelappui/views/ViewDetails/viewDetails.dart';
import 'package:travelappui/views/Login/login.dart';
import 'package:travelappui/views/Register/register.dart';
import 'package:travelappui/views/Welcome/welcome.dart';
import 'package:travelappui/views/Profile/profile.dart';
import 'package:travelappui/views/Settings/settings.dart';
import 'package:travelappui/views/Support/support.dart';
import 'package:travelappui/views/Voucher/voucher.dart';
import 'package:travelappui/views/VoucherDetail/voucherdetail.dart';
import 'package:travelappui/views/YourOrder/yourorder.dart';
import 'package:travelappui/views/PaymentMethod/paymentmethod.dart';
import 'package:travelappui/views/PaymentMethod2/paymentmethod2.dart';
import 'package:travelappui/views/PaymentMethod3/paymentmethod3.dart';

class AppRoutes {
  static const String ROUTE_Initial = ROUTE_WELCOME;
  static const String ROUTE_Home = "/home";
  static const String ROUTE_Splashscreen = "/splash";
  static const String ROUTE_ViewDetails = "/view";
  static const String ROUTE_Login = "/login";
  static const String ROUTE_REGISTER = "/register";
  static const String ROUTE_WELCOME = "/welcome";
  static const String Route_Iterasi = "/viewIterasi";
  static const String Route_Profile = "/profile";
  static const String Route_Settings = "/settings";
  static const String Route_Support = "/support";
  static const String Route_Voucher = "/voucher";
  static const String Route_VoucherDetail = "/voucherdetail";
  static const String Route_YourOrder = "/yourorder";
  static const String Route_PaymentMethod = "/paymentmethod";
  static const String Route_PaymentMethod2 = "/paymentmethod2";
  static const String Route_PaymentMethod3 = "/paymentmethod3";

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_Home:
        return MaterialPageRoute(
            settings: settings, builder: (_) => HomePage());

      case ROUTE_Splashscreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => SplashScreen());

      case ROUTE_ViewDetails:
        final placeModel = settings.arguments as PlaceModel?;
        if (placeModel == null) {
          return _unknownRoute(settings);
        }
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ViewDetails(placeModel: placeModel));

      case ROUTE_Login:
        return MaterialPageRoute(
            settings: settings, builder: (_) => LoginPage());

      case ROUTE_REGISTER:
        return MaterialPageRoute(
            settings: settings, builder: (_) => RegisterPage());

      case ROUTE_WELCOME:
        return MaterialPageRoute(
            settings: settings, builder: (_) => WelcomePage());

      case Route_Profile:
        return MaterialPageRoute(
            settings: settings, builder: (_) => ProfilePage());

      case Route_Settings:
        return MaterialPageRoute(
            settings: settings, builder: (_) => SettingsPage());

      case Route_Support:
        return MaterialPageRoute(
            settings: settings, builder: (_) => SupportPage());

      case Route_Voucher:
        return MaterialPageRoute(
            settings: settings, builder: (_) => VoucherPage());

      case Route_VoucherDetail:
        return MaterialPageRoute(
            settings: settings,builder: (_) => VoucherDetailPage());

     case Route_YourOrder:
        return MaterialPageRoute(
            settings: settings,builder: (_) => YourOrderPage(),);

      case Route_PaymentMethod:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) {
          return _unknownRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PaymentMethodPage(
            destination: args['destination'],
            order_info: args['order_info'],
          ),
        );

      case Route_PaymentMethod2:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) {
          return _unknownRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PaymentMethod2Page(
            destination: args['destination'],
            order_info: args['order_info'],
            payment_method: args['payment_method'],
          ),
        );

      case Route_PaymentMethod3:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) {
          return _unknownRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PaymentMethod3Page(
            total: args["total"],
            payment_method: args["payment_method"],
            ref_id: args["ref_id"]
          ),
        );

      default:
        return _unknownRoute(settings);
    }
  }

  static Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings, builder: (_) => UnknownPage());
  }
}

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unknown Page'),
      ),
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}