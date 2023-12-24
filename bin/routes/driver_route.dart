import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../handlers/driver_handler/get_rating_handler.dart';
import '../handlers/driver_handler/response_to_order_handler.dart';
import '../middlewares/user_middleware.dart';

class DriverRoute {
  Handler get route {
    final Router appRoute = Router()
      ..post("/response_to_order", responseToOrderHandler)
      ..get("/get_rating", getRatingHandler);

    final pipe =
        Pipeline().addMiddleware(checkToken()).addHandler(appRoute.call);

    return pipe;
  }
}
