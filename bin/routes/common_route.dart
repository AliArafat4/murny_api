import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../handlers/driver_handler/get_rating_handler.dart';
import '../handlers/driver_handler/response_to_order_handler.dart';
import '../handlers/common_hndlers/get_order_handler.dart';
import '../middlewares/user_middleware.dart';

class CommonRoute {
  Handler get route {
    final Router appRoute = Router()..get("/get_order", getOrderHandler);

    final pipe = Pipeline().addMiddleware(checkToken()).addHandler(appRoute);

    return pipe;
  }
}
