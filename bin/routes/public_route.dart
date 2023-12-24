import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../handlers/public_handler/get_carts_handler.dart';

class PublicRoute {
  Handler get route {
    final Router appRoute = Router()..get("/get_carts", getCartsHandler);

    return appRoute.call;
  }
}
