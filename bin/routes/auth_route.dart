import 'package:shelf_router/shelf_router.dart';
import '../handlers/auth_handlers/driver_sign_up_dandler.dart';
import '../handlers/auth_handlers/otp_handler.dart';
import '../handlers/auth_handlers/resend_otp_handler.dart';
import '../handlers/auth_handlers/sign_in_handler.dart';
import '../handlers/auth_handlers/sign_in_with_apple_handler.dart';
import '../handlers/auth_handlers/sign_in_with_google_handler.dart';
import '../handlers/auth_handlers/user_sign_up_handler.dart';

class AuthRoute {
  Router get route {
    return Router()
      ..post("/user_sign_up", userSignUpHandler)
      ..post("/driver_sign_up", driverSignUpHandler)
      ..post("/sign_in_with_apple", userSignInWithAppleHandler)
      ..post("/sign_in_with_google", userSignInWithGoogleHandler)
      ..post("/otp", otpHandler)
      ..post("/resend_otp", resendOtpHandler)
      ..post("/sign_in", signInHandler);
  }
}
