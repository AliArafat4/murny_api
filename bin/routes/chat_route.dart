import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../handlers/chat_handler/get_message_handler.dart';
import '../handlers/chat_handler/send_message_handler.dart';
import '../middlewares/user_middleware.dart';

class ChatRoute {
  Handler get route {
    final Router appRoute = Router()
      ..post("/send_message", sendMessageHandler)
      ..post("/get_message", getMessageHandler);

    final pipe = Pipeline().addMiddleware(checkToken()).addHandler(appRoute);

    return pipe;
  }
}
