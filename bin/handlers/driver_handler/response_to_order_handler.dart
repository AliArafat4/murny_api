import 'package:shelf/shelf.dart';

responseToOrderHandler(Request req) {
  return Response.ok(req.toString());
}
