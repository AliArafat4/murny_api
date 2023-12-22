import 'package:shelf/shelf.dart';

getMessageHandler(Request req) {
  return Response.ok(req.toString());
}
