import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'auth_route.dart';

import 'chat_route.dart';
import 'common_route.dart';
import 'driver_route.dart';
import 'profile_route.dart';
import 'user_route.dart';

class MainRoute {
  Router get route {
    return Router()
      ..get('/', (Request req) => Response.badRequest(body: "No EndPoint"))
      ..mount('/auth', AuthRoute().route)
      ..mount('/user', UserRoute().route)
      ..mount('/driver', DriverRoute().route)
      ..mount('/profile', ProfileRoute().route)
      ..mount('/chat', ChatRoute().route)
      ..mount('/common', CommonRoute().route)
      ..all('/<ignored|.*>',
          (Request req) => Response.badRequest(body: "No EndPoint"));
  }
}
