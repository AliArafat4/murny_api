import 'package:shelf_router/shelf_router.dart';
import '../handlers/auth_handlers/driver_sign_up_dandler.dart';
import '../handlers/auth_handlers/otp_handler.dart';
import '../handlers/auth_handlers/sign_in_handler.dart';
import '../handlers/auth_handlers/user_sign_up_handler.dart';

class AuthRoute {
  Router get route {
    return Router()
      ..post("/user_sign_up", userSignUpHandler)
      ..post("/driver_sign_up", driverSignUpHandler)
      ..post("/otp", otpHandler)
      ..post("/sign_in", signInHandler);
  }
}
