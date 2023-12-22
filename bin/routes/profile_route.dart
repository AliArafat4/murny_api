import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../handlers/profile_handler/delete_account_handler.dart';
import '../handlers/profile_handler/get_profile_handler.dart';
import '../handlers/profile_handler/update_driver_profile_handler.dart';
import '../handlers/profile_handler/update_user_profile_handler.dart';
import '../handlers/profile_handler/upload_avatar_handler.dart';
import '../handlers/profile_handler/upload_license_handler.dart';
import '../middlewares/user_middleware.dart';

class ProfileRoute {
  Handler get route {
    final Router appRoute = Router()
      ..post("/update_user_profile", updateUserProfileHandler)
      ..post("/update_driver_profile", updateDriverProfileHandler)
      ..post("/upload_avatar", uploadAvatarHandler)
      ..post("/upload_driver_license", uploadLicenseHandler)
      ..get("/get_profile", getProfileHandler)
      ..delete("/delete_user_account", deleteAccountHandler);

    final pipe = Pipeline().addMiddleware(checkToken()).addHandler(appRoute);

    return pipe;
  }
}
