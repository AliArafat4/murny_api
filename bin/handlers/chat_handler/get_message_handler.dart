import 'package:shelf/shelf.dart';

sendMessageHandler(Request req) {
  return Response.ok(req.toString());
}
