import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../handlers/user_handlers/cancel_order_handler.dart';
import '../handlers/user_handlers/get_user_by_id.dart';
import '../handlers/user_handlers/post_order_handler.dart';
import '../handlers/user_handlers/post_rating_handler.dart';
import '../middlewares/user_middleware.dart';

class UserRoute {
  Handler get route {
    final Router appRoute = Router()
      ..post("/post_rating", postRatingHandler)
      ..post("/cancel_order", cancelOrderHandler)
      ..post("/get_user_by_id", getUserByIDHandler)
      ..post("/post_user_order", postOrderHandler);

    final pipe =
        Pipeline().addMiddleware(checkToken()).addHandler(appRoute.call);

    return pipe;
  }
}
