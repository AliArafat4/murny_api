import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../handlers/common_handlers/get_order_handler.dart';
import '../middlewares/user_middleware.dart';

class CommonRoute {
  Handler get route {
    final Router appRoute = Router()..get("/get_order", getOrderHandler);

    final pipe =
        Pipeline().addMiddleware(checkToken()).addHandler(appRoute.call);

    return pipe;
  }
}
